`import Ember from 'ember'`

AppRoute = Ember.Route.extend
  model: ->
    ctrl = @controllerFor 'application'
    if Ember.isBlank ctrl.get('model')
      @store.find 'post'

`export default AppRoute`
