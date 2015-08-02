`import Ember from 'ember'`
`import CW from './core'`

Ember.onLoad 'Ember.Application', (Application) ->
  Application.initializer
    name: 'coreweb'
    initialize: (registry, app) ->
      registry.register 'adapter:-cw', CW.Adapter
      registry.register 'adapter:-parse', CW.ParseAdapter

      registry.register 'store:-cw', CW.Store
      registry.injection 'controller', 'store', 'store:-cw'
      registry.injection 'route', 'store', 'store:-cw'

  Application.instanceInitializer
    name: 'coreweb'
    initialize: (instance) ->
      CW.Model.reopen store: instance.container.lookup("store:-cw")
