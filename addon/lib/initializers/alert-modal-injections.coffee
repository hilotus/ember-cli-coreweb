initializeAlertModalInjections = (registry) ->
  registry.injection 'route', 'am', 'modal:alert'
  registry.injection 'model', 'am', 'modal:alert'
  registry.injection 'component', 'am', 'modal:alert'
  registry.injection 'controller', 'am', 'modal:alert'

  registry.injection 'route', 'cm', 'modal:confirm'
  registry.injection 'model', 'cm', 'modal:confirm'
  registry.injection 'component', 'cm', 'modal:confirm'
  registry.injection 'controller', 'cm', 'modal:confirm'

  registry.injection 'route', 'spin', 'modal:spin'
  registry.injection 'model', 'spin', 'modal:spin'
  registry.injection 'component', 'spin', 'modal:spin'
  registry.injection 'controller', 'spin', 'modal:spin'

  registry.injection 'route', 'closeSpinner', 'modal:closespinner'
  registry.injection 'model', 'closeSpinner', 'modal:closespinner'
  registry.injection 'component', 'closeSpinner', 'modal:closespinner'
  registry.injection 'controller', 'closeSpinner', 'modal:closespinner'

  registry.injection 'route', 'closeModal', 'modal:closemodal'
  registry.injection 'model', 'closeModal', 'modal:closemodal'
  registry.injection 'component', 'closeModal', 'modal:closemodal'
  registry.injection 'controller', 'closeModal', 'modal:closemodal'

`export default initializeAlertModalInjections`
