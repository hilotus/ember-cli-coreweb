`import initializeAdapter from 'ember-cli-coreweb/lib/initializers/adapter'`
`import initializeStore from 'ember-cli-coreweb/lib/initializers/store'`
`import initializeStoreInjections from 'ember-cli-coreweb/lib/initializers/store-injections'`

setupContainer = (container, application) ->
  initializeAdapter container, application
  initializeStore container, application
  initializeStoreInjections container, application

`export default setupContainer`
