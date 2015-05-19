`import Ember from 'ember'`

__cache__ = {}

`export __cache__`

Store = Ember.Object.extend
  find: (clazz, id) ->
    return @findById clazz, id if typeof id is 'string'


  findById: (clazz, id) ->
    clazz = @__getModelClazz clazz
    adapter = @container.lookup 'adapter:cw'
    typeKey = clazz.typeKey
    self = @

    return Ember.RSVP.resolve record if __cache__[typeKey] and (record = __cache__[typeKey][id])

  # Get Model Class by class name.
  __getModelClazz: (clazz) ->
    return clazz if typeof clazz isnt 'string'
    @container.lookup("model:#{clazz.toLowerCase()}").constructor

  # find from cache
  __findFromCache: (typeKey, query) ->


`export default Store`
