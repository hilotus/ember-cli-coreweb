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

  getClassTypeKey: (clazz, method) ->
    if typeof clazz isnt "string"
      clazz.typeKey.classify()
    else
      clazz.classify()

  # This methods must be override.
  # Maybe you can use ic-ajax.
  ajax: (url, type, options) ->
    Ember.RSVP.reject error: 'You must override ajax method in applicationAdapter.'

`export default Adapter`
