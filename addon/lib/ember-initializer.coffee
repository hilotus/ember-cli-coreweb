`import Ember from 'ember'`
`import setupContainer from 'ember-cli-coreweb/lib/setup-container'`
`import Model from 'ember-cli-coreweb/lib/model'`

K = Ember.K

Ember.onLoad 'Ember.Application', (Application) ->
  Application.initializer
    name: 'coreweb'
    initialize: setupContainer

  Application.initializer
    name: 'store'
    after: 'coreweb'
    initialize: K

  Application.initializer
    name: 'adapter'
    before: 'store'
    initialize: K

  Application.initializer
    name: 'injectStore'
    before: 'store'
    initialize: K

  Application.initializer
    name: 'alertModal'
    before: 'store'
    initialize: K

  Application.initializer
    name: 'InjectAlertModal'
    before: 'store'
    initialize: K

  Application.initializer
    name: 'markdownEditor'
    before: 'store'
    initialize: K

  Application.instanceInitializer
    name: 'injectModel'
    initialize: (instance) ->
      Model.reopen store: instance.container.lookup("store:-cw")
