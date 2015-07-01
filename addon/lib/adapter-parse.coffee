`import Adapter from './adapter'`

AdapterParse = Adapter.extend
  findByIds: (clazz, ids) ->
    @find clazz, {where: {objectId: {"$all": ids}}}

  getClassTypeKey: (clazz, method='') ->
    clazz = @_super clazz, method

    if clazz.match(/User/)
      "users"
    else
      clazz

`export default AdapterParse`
