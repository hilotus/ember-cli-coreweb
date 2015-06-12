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

  registry.injection 'route', 'unspin', 'modal:unspin'
  registry.injection 'model', 'unspin', 'modal:unspin'
  registry.injection 'component', 'unspin', 'modal:unspin'
  registry.injection 'controller', 'unspin', 'modal:unspin'

`export default initializeAlertModalInjections`
