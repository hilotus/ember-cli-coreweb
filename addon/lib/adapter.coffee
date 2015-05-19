`import Ember from 'ember'`

AppAdapter = Ember.Object.extend
  # clazz: model class
  # id: is a string or a query json
  find: (clazz, id) ->
    return @findById clazz, id if typeof id is "string"

    if typeof clazz isnt "string"
      clazz = clazz.typeKey

    # id is a query json
    @ajax clazz, "GET", data: id

  # clazz: model class
  # id: is a string
  findById: (clazz, id) ->
    if typeof clazz isnt "string"
      clazz = clazz.typeKey

    @ajax clazz + "/" + id, "GET"

  # clazz: model class
  # ids: ids is an array
  findByIds: (clazz, ids) ->
    if typeof clazz isnt "string"
      clazz = clazz.typeKey

    @ajax clazz + "/ids", "POST", data: {ids: ids}

  # clazz: model class
  # data: request json for create
  createRecord: (clazz, data) ->
    if typeof clazz isnt "string"
      clazz = clazz.typeKey

    @ajax clazz, "POST", data: data

  # clazz: model class
  # id: record id
  # data: json data for update
  updateRecord: (clazz, id, data) ->
    if typeof clazz isnt "string"
      clazz = clazz.typeKey

    @ajax clazz + "/" + id, "PUT", data: data

  # clazz: model class
  # id: record id
  destroyRecord: (clazz, id) ->
    if typeof clazz isnt "string"
      clazz = clazz.typeKey

    @ajax clazz + "/" + id, "DELETE"

  # This methods must be override.
  # Maybe you can use ic-ajax.
  ajax: (url, type, options) ->
    Ember.RSVP.reject error: 'You must override ajax method in applicationAdapter.'

`export defualt AppAdapter`
