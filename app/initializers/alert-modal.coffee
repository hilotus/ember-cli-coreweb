`import Ember from 'ember'`
`import Alert from 'ember-cli-coreweb/utils/alert'`
`import Confirm from 'ember-cli-coreweb/utils/confirm'`

initialize = (container, application) ->
  application.register 'utils:am', Alert
  application.inject 'route', 'am', 'utils:am'
  application.inject 'model', 'am', 'utils:am'
  application.inject 'component', 'am', 'utils:am'
  application.inject 'controller', 'am', 'utils:am'

  application.register 'utils:cm', Confirm
  application.inject 'route', 'cm', 'utils:cm'
  application.inject 'model', 'cm', 'utils:cm'
  application.inject 'component', 'cm', 'utils:cm'
  application.inject 'controller', 'cm', 'utils:cm'

AlertModalInitializer =
  nalerte: 'alert-modal'
  initialize: initialize

`export default AlertModalInitializer`
