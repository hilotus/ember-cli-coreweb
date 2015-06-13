`import Ember from 'ember'`

__cache__ = {}

Store = Ember.Object.extend
  adapter: '-cw'

  adapterFor: ->
    unless (adapter = @container.lookup 'adapter:application')
      adapter = @container.lookup "adapter:#{@adapter}"
    adapter

  find: (clazz, id={}) ->
    return @findById clazz, id if typeof id is 'string'

    clazz = @__getModelClazz clazz
    typeKey = clazz.typeKey
    self = @

    @adapterFor().find(clazz, id).then (json) ->
      records = json.results.map (result) ->
        self.push clazz, result
      Ember.RSVP.resolve records
    , (reason) ->
      Ember.RSVP.reject reason

  findById: (clazz, id) ->
    clazz = @__getModelClazz clazz
    typeKey = clazz.typeKey
    self = @

    if __cache__[typeKey] and (record = __cache__[typeKey][id])
      return Ember.RSVP.resolve record

    @adapterFor().find(clazz, id).then (json) ->
      Ember.RSVP.resolve self.push(clazz, json)
    , (reason) ->
      Ember.RSVP.reject reason

  findByIds: (clazz, ids) ->
    throw new Ember.Error 'ids must be an array.' unless Ember.isArray ids

    clazz = @__getModelClazz clazz
    typeKey = clazz.typeKey
    records = []
    self = @

    if __cache__[typeKey]
      ids.forEach (id, index) ->
        if __cache__[typeKey][id]
          records.pushObject __cache__[typeKey][id]

      if ids.length is records.length
        return Ember.RSVP.resolve records

    records = []
    @adapterFor().findByIds(clazz, ids).then (json) ->
      Ember.RSVP.resolve json.results.map (result) ->
        self.push clazz, result
    , (reason) ->
      Ember.RSVP.reject reason

  createRecord: (clazz, data) ->
    clazz = @__getModelClazz clazz
    self = @
    @adapterFor().createRecord(clazz, data).then (json) ->
      data.id = json._id || json.objectId
      Ember.merge data, json
      Ember.RSVP.resolve data
    , (reason) ->
      Ember.RSVP.reject reason

  updateRecord: (clazz, id, data) ->
    clazz = @__getModelClazz clazz
    self = @
    @adapterFor().updateRecord(clazz, id, data).then (json) ->
      Ember.RSVP.resolve json
    , (reason) ->
      Ember.RSVP.reject reason

  destroyRecord: (clazz, id) ->
    clazz = @__getModelClazz clazz
    @adapterFor().destroyRecord(clazz, id).then ->
      Ember.RSVP.resolve()
    , (reason) ->
      Ember.RSVP.reject reason

  # Batch Request
  # Reference: https://www.parse.com/docs/rest#objects-batch
  # operations: {creates: [], updates: [], destroys: []}
  batch: (operations={}) ->
    adapter = @adapterFor()
    data = adapter.extractBatchData operations
    self = @
    adapter.batch(data.requests).then (json) ->
      # json is an array.
      json.forEach (r, i) ->
        record = data.records[i]
        unless $.isEmptyObject r.success  # create or update
          if json.success.objectId or json.success._id
            self.push record.constructor, json, record
          else
            self.reload record.getTypeKey(), json, record
        else
          self.pull record.getTypeKey(), record.get('id')
      Ember.RSVP.resolve()
    , (reason) ->
      Ember.RSVP.reject reason

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
  # record: modle instance/model id
  reload: (clazz, json, record) ->
    record = __cache__[clazz.typeKey][record] if typeof record is 'string'

    # use merged responseJson to update changeData
    Ember.merge json, record.get('changeData')
    record.merge json

    clazz = @__getModelClazz clazz
    __cache__[clazz.typeKey][record.get('id')] = record
    @__normalize record, record.get('modelData')

  # Delete a record from cache
  pull: (typeKey, id) ->
    if __cache__[typeKey][id]
      delete __cache__[typeKey][id]

  # set model properties
  # schema: {
  #   'belongTo': {'creator': 'user', 'category': 'term'},
  #   'hasMany': {'tags': 'term'}
  # }
  __normalize: (record, data) ->
    schema = record.constructor.schema

    for key, value of data
      if !Ember.isNone schema.belongTo[key]
        @__normalizeBelongTo record, schema.belongTo[key], key, value
      else if !Ember.isNone schema.hasMany[key]
        @__normalizeHasMany record, schema.hasMany[key], key, value
      else
        record.set key, @__normalizeEmbedded value
    record

  # record: model instance
  # typeKey: model id
  # key: model column name
  # value: model column value
  __normalizeBelongTo: (record, typeKey, key, value) ->
    @find(typeKey, value).then (r) ->
      record.set key, r

  # record: model instance
  # typeKey: model id
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
  __normalizeEmbedded: (data) ->
    if $.isPlainObject data  # check value is json data.
      v = Ember.Object.create();
      for key, value of data
        v.set key, @__normalizeEmbedded value
      v
    else
      data

  # Get Model Class by class name.
  __getModelClazz: (clazz) ->
    return clazz if typeof clazz isnt 'string'
    @container.lookup("model:#{clazz.toLowerCase()}").constructor

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
    @__normalize record, record.get('modelData')
    record

`export {__cache__}`
`export default Store`
