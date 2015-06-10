initializeAlertModalInjections = (registry) ->
  registry.injection 'route', 'am', 'modal:alert'
  registry.injection 'model', 'am', 'modal:alert'
  registry.injection 'component', 'am', 'modal:alert'
  registry.injection 'controller', 'am', 'modal:alert'

  registry.injection 'route', 'cm', 'modal:confirm'
  registry.injection 'model', 'cm', 'modal:confirm'
  registry.injection 'component', 'cm', 'modal:confirm'
  registry.injection 'controller', 'cm', 'modal:confirm'

`export default initializeAlertModalInjections`
