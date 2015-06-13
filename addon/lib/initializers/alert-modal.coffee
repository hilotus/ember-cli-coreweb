`import Ember from 'ember'`
`import Alert from 'ember-cli-coreweb/utils/alert'`
`import Confirm from 'ember-cli-coreweb/utils/confirm'`
`import Spin from 'ember-cli-coreweb/utils/spin'`
`import CloseSpinner from 'ember-cli-coreweb/utils/closespinner'`
`import CloseModal from 'ember-cli-coreweb/utils/closemodal'`

initializeAlertModal = (registry, application) ->
  application.register 'modal:alert', Alert
  application.register 'modal:confirm', Confirm
  application.register 'modal:spin', Spin
  application.register 'modal:closespinner', CloseSpinner
  application.register 'modal:closemodal', CloseModal

`export default initializeAlertModal`
