`import Ember from 'ember'`

CWRoute = Ember.Route.extend
  model: ->
    ctrl = @controllerFor 'todos'
    if Ember.isBlank ctrl.get('model')
      @store.find 'todo'

`export default CWRoute`
