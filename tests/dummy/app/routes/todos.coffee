`import Ember from 'ember'`

CWRoute = Ember.Route.extend
  model: ->
    @store.find 'todo'

`export default CWRoute`
