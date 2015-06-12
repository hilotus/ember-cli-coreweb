`import initializeAdapter from 'ember-cli-coreweb/lib/initializers/adapter'`
`import initializeStore from 'ember-cli-coreweb/lib/initializers/store'`
`import initializeStoreInjections from 'ember-cli-coreweb/lib/initializers/store-injections'`

`import initializeAlertModal from 'ember-cli-coreweb/lib/initializers/alert-modal'`
`import initializeAlertModalInjections from 'ember-cli-coreweb/lib/initializers/alert-modal-injections'`
`import initializeMDEditor from 'ember-cli-coreweb/lib/initializers/md'`

setupContainer = (container, application) ->
  initializeAdapter container, application
  initializeStore container, application
  initializeStoreInjections container, application

  initializeAlertModal container, application
  initializeAlertModalInjections container, application

  initializeMDEditor container, application

`export default setupContainer`
