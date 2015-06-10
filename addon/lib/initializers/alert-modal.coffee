`import Ember from 'ember'`
`import Alert from 'ember-cli-coreweb/utils/alert'`
`import Confirm from 'ember-cli-coreweb/utils/confirm'`

initializeAlertModal = (registry, application) ->
  application.register 'modal:alert', Alert
  application.register 'modal:confirm', Confirm

`export default initializeAlertModal`
