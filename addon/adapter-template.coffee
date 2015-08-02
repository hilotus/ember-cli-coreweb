adapter =
  # id: is a string or a query json
  find: (modelTypeKey, id) ->
    return @findById modelTypeKey, id if typeof id is "string"

    # id is a query json
    @ajax @getEndPoint(modelTypeKey), "GET", data: id

  # id: is a string
  findById: (modelTypeKey, id) ->
    @ajax @getEndPoint(modelTypeKey) + "/" + id, "GET"

  # ids: ids is an array
  findByIds: (modelTypeKey, ids) ->
    @ajax @getEndPoint(modelTypeKey) + "/ids", "POST", data: {ids: ids}

  # data: request json for create
  createRecord: (modelTypeKey, data) ->
    @ajax @getEndPoint(modelTypeKey), "POST", data: data

  # id: record id
  # data: json data for update
  updateRecord: (modelTypeKey, id, data) ->
    @ajax @getEndPoint(modelTypeKey) + "/" + id, "PUT", data: data

  # id: record id
  destroyRecord: (modelTypeKey, id) ->
    @ajax @getEndPoint(modelTypeKey) + "/" + id, "DELETE"

  getEndPoint: (modelTypeKey) ->
    modelTypeKey

`export default adapter`
