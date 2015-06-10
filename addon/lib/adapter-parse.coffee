`import Adapter from './adapter'`

AdapterParse = Adapter.extend
  getClassTypeKey: (clazz, method='') ->
    clazz = @_super clazz, method

    if clazz.match(/User/)
      if method is 'find'
        "_#{clazz}"
      else if method is 'findById' or method is 'updateRecord'
        "users"
      else
        clazz
    else
      clazz

`export default AdapterParse`
