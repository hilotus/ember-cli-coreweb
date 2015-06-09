`import Ember from 'ember'`
`import Alert from 'ember-cli-coreweb/utils/alert'`
`import Confirm from 'ember-cli-coreweb/utils/confirm'`

initializeAlertModal = (registry, application) ->
  application.register 'utils:am', Alert
  application.register 'utils:cm', Confirm

`export default initializeAlertModal`
