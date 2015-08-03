`import Ember from 'ember'`

__cache__ = {}

Store = Ember.Object.extend
  # this.adapter is dependent by CW config in environment.

  find: (modelTypeKey, id={}) ->
    return @findById modelTypeKey, id if typeof id is 'string'

    self = @
    @adapter.find(modelTypeKey, id).then (json) ->
      if Ember.isBlank json.results
        return Ember.RSVP.reject new Ember.Error 'Find response must contains <results> column.'

      records = json.results.map (result) ->
        self.push modelTypeKey, result
      Ember.RSVP.resolve records

  findById: (modelTypeKey, id) ->
    self = @
    if __cache__[modelTypeKey] and (record = __cache__[modelTypeKey][id])
      return Ember.RSVP.resolve record

    @adapter.find(modelTypeKey, id).then (json) ->
      Ember.RSVP.resolve self.push(modelTypeKey, json)

  findByIds: (modelTypeKey, ids) ->
    return Ember.RSVP.reject new Ember.Error 'ids must be an array.' unless Ember.isArray ids

    records = []
    self = @

    if __cache__[modelTypeKey]
      ids.forEach (id, index) ->
        if __cache__[modelTypeKey][id]
          records.pushObject __cache__[modelTypeKey][id]

      if ids.length is records.length
        return Ember.RSVP.resolve records

    records = []
    @adapter.findByIds(modelTypeKey, ids).then (json) ->
      Ember.RSVP.resolve json.results.map (result) ->
        self.push modelTypeKey, result

  createRecord: (modelTypeKey, data, record) ->
    self = @
    @adapter.createRecord(modelTypeKey, data).then (json) ->
      if json.errors
        Ember.RSVP.reject new Ember.Error errors[0].msg
      else if json.changeSet
        self.applyChangesetHash json.ChangeSet
        Ember.RSVP.resolve()
      else
        data.id = json._id || json.objectId
        Ember.merge data, json
        self.push modelTypeKey, data, record
        Ember.RSVP.resolve()

  updateRecord: (modelTypeKey, id, data) ->
    self = @
    @adapter.updateRecord(modelTypeKey, id, data).then (json) ->
      if json.errors
        Ember.RSVP.reject new Ember.Error errors[0].msg
      else if json.changeSet
        self.applyChangesetHash json.ChangeSet
        Ember.RSVP.resolve()
      else
        self.reload modelTypeKey, json, id
        Ember.RSVP.resolve()

  destroyRecord: (modelTypeKey, id) ->
    self = @
    @adapter.destroyRecord(modelTypeKey, id).then (json) ->
      if json.errors
        Ember.RSVP.reject new Ember.Error errors[0].msg
      else if json.changeSet
        self.applyChangesetHash json.ChangeSet
        Ember.RSVP.resolve()
      else
        self.pull modelTypeKey, id
        Ember.RSVP.resolve()

  # auto commit the changes model
  commitChanges: ->
    models = []
    for modelTypeKey, collection of __cache__
      for modelId, model of collection
        models.push model

    new Ember.RSVP.Promise (resolve, reject) ->
      async.eachSeries models, (model, callback) ->
        model.commitChanges().then(->
          callback null
        ).catch((err) ->
          callback err
        )
      , (err) ->
        if err then Ember.run null, reject, err else Ember.run null, resolve

  # push record(s) into store
  # clazz: string / model class
  push: (clazz, json, record) ->
    self = @
    if Ember.isArray json
      records = []
      json.map (j) ->
        self.__push clazz, j, record
    else
      self.__push clazz, json, record

  # Update a record in cache
  reload: (modelTypeKey, json, id) ->
    record = __cache__[modelTypeKey][id]
    throw new Ember.Error("There is no #{modelTypeKey} exists find by id #{id}.") unless record

    # use merged responseJson to update changeData
    Ember.merge json, record.get('changeData')
    record.merge json

    __cache__[modelTypeKey][record.get('id')] = record
    @normalize record, record.get('modelData')

  # Delete a record from cache
  pull: (typeKey, id) ->
    @__pull typeKey, id

  # set model properties
  # schema: {
  #   'belongTo': {'creator': 'user', 'category': 'term'},
  #   'hasMany': {'tags': 'term'}
  # }
  normalize: (record, data) ->
    schema = record.constructor.schema

    for key, value of data
      if !Ember.isNone schema.belongTo[key]
        @__normalizeBelongTo record, schema.belongTo[key], key, value
      else if !Ember.isNone schema.hasMany[key]
        @__normalizeHasMany record, schema.hasMany[key], key, value
      else
        record.set key, @__normalizeNormal value
    record

  # changeSet format: {inserts: {User: []}, updates: {Post: []}, deletes: {Comment:[]}}
  # errors formats: [{code: 578, error: '...'}]
  applyChangesetHash: (changeSetJson) ->
    inserts = changeSetJson.inserts
    updates = changeSetJson.updates
    deletes = changeSetJson.deletes
    models = @__getModels
    self = @

    if Ember.isBlank(inserts) and Ember.isBlank(updates) and Ember.isBlank(deletes)
      Ember.debug("Skipping applyChangesetHash logic. Received empty changeset response.")
      return false

    if deletes
      for modelTypeKey in models
        records = deletes[modelTypeKey] or [];
        for record in records
          recordId = record.id or record._id or record.objectId
          self.pull modelTypeKey, recordId

    if updates
      @__loadData updates, 2

    if inserts
      @__loadData inserts, 1

  ##############

  # record: model instance
  # typeKey: model type key
  # key: model column name
  # value: model column value
  __normalizeBelongTo: (record, typeKey, key, value) ->
    @find(typeKey, value).then (r) ->
      record.set key, r

  # record: model instance
  # typeKey: model type key
  # key: model column name
  # values: is an ids array
  __normalizeHasMany: (record, typeKey, key, values) ->
    # @findByIds(typeKey, values).then (records) ->
    #   record.set key, records
    self = @
    record.set key, []
    values.forEach (value) ->
      self.find(typeKey, value).then (r) ->
        record.get(key).pushObject(r);

  # data: model column value
  __normalizeNormal: (data) ->
    if $.isPlainObject data  # check value is json data.
      v = Ember.Object.create();
      for key, value of data
        v.set key, @__normalizeNormal value
      v
    else
      data

  # clazz: class or model type key
  # Get Model Class by class name.
  __getModelClazz: (clazz) ->
    return clazz if typeof clazz isnt 'string'
    @container.lookup("model:#{clazz.toLowerCase()}").constructor

  # clazz: class or model type key
  # Push a record into store cache
  __push: (clazz, json, record) ->
    clazz = @__getModelClazz clazz
    json.id = json.id or json._id or json.objectId
    delete json._id
    delete json.objectId
    __cache__[clazz.typeKey] = {} unless __cache__[clazz.typeKey]

    if Ember.isNone(record)
      unless __cache__[clazz.typeKey][json.id] # Only there is no cache, create a nre record.
        record = clazz.create()
      else
        record = __cache__[clazz.typeKey][json.id]

    record.merge json
    __cache__[clazz.typeKey][json.id] = record

    # normalize record.
    @normalize record, record.get('modelData')

    record.set 'status', 'persistent'
    record

  __pull: (typeKey, id) ->
    if (record = __cache__[typeKey][id])
      record.set 'status', 'distroyed'
      delete __cache__[typeKey][id]

  # Load models from app env.
  __getModels: ->
    @defaultModels or []

  __loadRecords: (modelTypeKey, records, type) ->
    batch_count = 1000
    models = @__getModels()
    self = @

    if records.length > batch_count
      recordsSpliced = records
      records = records.splice(0, 1000)

      Ember.run.later(() ->
        self.__loadRecords modelTypeKey, recordsSpliced, type
      , 10)

    for record in records
      if type is 1
        self.push modelTypeKey, record
      else if type is 2
        self.reload modelTypeKey, record, (record.id or record._id or record.objectId)

  # TODO: return the last insert's record
  # type: 1, insert; 2, update
  __loadData: (result, type) ->
    models = @__getModels
    self = @

    for modelTypeKey in models
      records = result[modelTypeKey]
      # Load Records
      if Ember.isArray(records)
       self.__loadRecords modelTypeKey, records, type

`export default Store`
