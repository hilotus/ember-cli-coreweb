initializeAlertModalInjections = (registry) ->
  registry.injection 'route', 'openAlert', 'modal:alert'
  registry.injection 'model', 'openAlert', 'modal:alert'
  registry.injection 'component', 'openAlert', 'modal:alert'
  registry.injection 'controller', 'openAlert', 'modal:alert'

  registry.injection 'route', 'openConfirm', 'modal:confirm'
  registry.injection 'model', 'openConfirm', 'modal:confirm'
  registry.injection 'component', 'openConfirm', 'modal:confirm'
  registry.injection 'controller', 'openConfirm', 'modal:confirm'

  registry.injection 'route', 'openSpinner', 'modal:spin'
  registry.injection 'model', 'openSpinner', 'modal:spin'
  registry.injection 'component', 'openSpinner', 'modal:spin'
  registry.injection 'controller', 'openSpinner', 'modal:spin'

  registry.injection 'route', 'closeSpinner', 'modal:closespinner'
  registry.injection 'model', 'closeSpinner', 'modal:closespinner'
  registry.injection 'component', 'closeSpinner', 'modal:closespinner'
  registry.injection 'controller', 'closeSpinner', 'modal:closespinner'

  # close alert and confirm modal
  registry.injection 'route', 'closeModal', 'modal:closemodal'
  registry.injection 'model', 'closeModal', 'modal:closemodal'
  registry.injection 'component', 'closeModal', 'modal:closemodal'
  registry.injection 'controller', 'closeModal', 'modal:closemodal'

`export default initializeAlertModalInjections`
