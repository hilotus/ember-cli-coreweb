`import Store from 'ember-cli-coreweb/lib/store'`

initializeStore = (registry, application) ->
  registry.register 'store:-cw', (application and application.Store) or Store

`export default initializeStore`
