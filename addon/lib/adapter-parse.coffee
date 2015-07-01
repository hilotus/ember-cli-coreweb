`import Adapter from './adapter'`

AdapterParse = Adapter.extend
  getClassTypeKey: (clazz, method='') ->
    clazz = @_super clazz, method

    if clazz.match(/User/)
      "users"
    else
      clazz

`export default AdapterParse`
