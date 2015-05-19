`import Ember from 'ember'`

__cache__ = {}

`export __cache__`

Store = Ember.Object.extend
  find: (clazz, id={}) ->
    return @findById clazz, id if typeof id is 'string'

    clazz = @__getModelClazz clazz
    adapter = @container.lookup 'adapter:cw'
    typeKey = clazz.typeKey
    self = @

    adapter.find(clazz, id).then (json) ->
      Ember.RSVP.resolve json.results.map (result) ->
        self.push clazz, result
    , (reason) ->
      Ember.RSVP.reject reason

  findById: (clazz, id) ->
    clazz = @__getModelClazz clazz
    adapter = @container.lookup 'adapter:cw'
    typeKey = clazz.typeKey
    self = @

    return Ember.RSVP.resolve record if __cache__[typeKey] and (record = __cache__[typeKey][id])

    adapter.find(clazz, id).then (json) ->
      Ember.RSVP.resolve self.push(clazz, json)
    , (reason) ->
      Ember.RSVP.reject reason

  findByIds: (clazz, ids) ->
    throw new Ember.Error 'ids must be an array.' unless Ember.isArray ids

    clazz = @__getModelClazz clazz
    adapter = @container.lookup 'adapter:cw'
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
    adapter.findByIds(clazz, ids).then (json) ->
      Ember.RSVP.resolve json.results.map (result) ->
        self.push clazz, result
    , (reason) ->
      Ember.RSVP.reject reason

  createRecord: (clazz, data) ->
    clazz = @__getModelClazz clazz
    adapter = @container.lookup 'adapter:cw'
    self = @

    adapter.createRecord(clazz, data).then (json) ->
      data.id = json._id || json.objectId
      Ember.merge data, json
      Ember.RSVP.resolve data
    , (reason) ->
      Ember.RSVP.reject reason

  updateRecord: (clazz, id, data) ->
    clazz = @__getModelClazz clazz
    adapter = @container.lookup 'adapter:cw'
    self = @

    adapter.updateRecord(clazz, id, data).then (json) ->
      Ember.RSVP.resolve json
    , (reason) ->
      Ember.RSVP.reject reason

  destroyRecord: (clazz, id) ->
    clazz = @__getModelClazz clazz
    adapter = @container.lookup 'adapter:cw'

    adapter.destroyRecord(clazz, id).then ->
      Ember.RSVP.resolve()
    , (reason) ->
      Ember.RSVP.reject reason

  # push record(s) into store
  # clazz: string / model class
  push: (clazz, json, record) ->
    if Ember.isArray json
      records = []
      json.map (j) ->
        @__push clazz, j, record
    else
      @__push clazz, json, record

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
  # value: model column value
  __normalizeHasMany: (record, typeKey, key, value) ->
    this.findByIds(typeKey, value).then (records) ->
      record.set key, records

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

    __cache__[clazz.typeKey] = __cache__[clazz.typeKey] || {};
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

  # find from cache
  __findFromCache: (typeKey, query) ->


`export default Store`
