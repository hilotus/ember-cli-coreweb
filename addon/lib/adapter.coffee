`import Ember from 'ember'`

Adapter = Ember.Object.extend
  # clazz: model class
  # id: is a string or a query json
  find: (clazz, id) ->
    return @findById clazz, id if typeof id is "string"

    clazz = @getClassTypeKey clazz
    # id is a query json
    @ajax clazz, "GET", data: id

  # clazz: model class
  # id: is a string
  findById: (clazz, id) ->
    clazz = @getClassTypeKey clazz
    @ajax clazz + "/" + id, "GET"

  # clazz: model class
  # ids: ids is an array
  findByIds: (clazz, ids) ->
    clazz = @getClassTypeKey clazz
    @ajax clazz + "/ids", "POST", data: {ids: ids}

  # clazz: model class
  # data: request json for create
  createRecord: (clazz, data) ->
    clazz = @getClassTypeKey clazz
    @ajax clazz, "POST", data: data

  # clazz: model class
  # id: record id
  # data: json data for update
  updateRecord: (clazz, id, data) ->
    clazz = @getClassTypeKey clazz
    @ajax clazz + "/" + id, "PUT", data: data

  # clazz: model class
  # id: record id
  destroyRecord: (clazz, id) ->
    clazz = @getClassTypeKey clazz
    @ajax clazz + "/" + id, "DELETE"

  # Batch Operations:
  # https://www.parse.com/docs/rest#objects-batch
  batch: (requests) ->
    @ajax 'batch', 'POST', data: {requests: requests}

  extractBatchData: (operations) ->
    operations.creates = operations.creates or []
    operations.updates = operations.updates or []
    operations.destroys = operations.destroys or []
    requests = []
    records = []
    self = @

    for record in operations.creates
      requests.push
        method: 'POST'
        path: self.buildBatchPath record.getCapitalizeTypeKey()
        body: record.get 'modelData'
      records.push record

    for record in operations.updates
      requests.push
        method: 'PUT'
        path: self.buildBatchPath record.getCapitalizeTypeKey(), record.get('id')
        body: record.get 'changeData'
      records.push record

    for record in operations.updates
      requests.push
        method: 'DELETE'
        path: self.buildBatchPath record.getCapitalizeTypeKey(), record.get('id')
      records.push record

    requests: requests, records: records

  getClassTypeKey: (clazz) ->
    if typeof clazz isnt "string"
      clazz.typeKey.classify()
    else
      clazz.classify()

  # This methods must be override.
  # Maybe you can use ic-ajax.
  ajax: (url, type, options) ->
    Ember.RSVP.reject error: 'You must override ajax method in applicationAdapter.'

`export default Adapter`
