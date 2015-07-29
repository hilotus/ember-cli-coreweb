`import Ember from 'ember'`

AppRoute = Ember.Route.extend
  model: ->
    ctrl = @controllerFor 'todos'
    if Ember.isBlank ctrl.get('model')
      @store.find 'Todo'

`export default AppRoute`
