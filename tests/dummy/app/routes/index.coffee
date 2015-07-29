`import Ember from 'ember'`

IndexRoute = Ember.Route.extend
  model: ->
    ctrl = @controllerFor 'application'
    if Ember.isBlank ctrl.get('model')
      @store.find 'Post'

`export default IndexRoute`
