`import Ember from 'ember'`
`import Alert from 'ember-cli-coreweb/utils/alert'`
`import Confirm from 'ember-cli-coreweb/utils/confirm'`
`import Spin from 'ember-cli-coreweb/utils/spin'`
`import Unspin from 'ember-cli-coreweb/utils/unspin'`

initializeAlertModal = (registry, application) ->
  application.register 'modal:alert', Alert
  application.register 'modal:confirm', Confirm
  application.register 'modal:spin', Spin
  application.register 'modal:unspin', Unspin

`export default initializeAlertModal`
