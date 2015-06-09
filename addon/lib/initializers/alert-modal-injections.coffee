initializeAlertModalInjections = (registry) ->
  registry.injection 'route', 'am', 'utils:am'
  registry.injection 'model', 'am', 'utils:am'
  registry.injection 'component', 'am', 'utils:am'
  registry.injection 'controller', 'am', 'utils:am'

  registry.injection 'route', 'cm', 'utils:cm'
  registry.injection 'model', 'cm', 'utils:cm'
  registry.injection 'component', 'cm', 'utils:cm'
  registry.injection 'controller', 'cm', 'utils:cm'

`export default initializeAlertModalInjections`
