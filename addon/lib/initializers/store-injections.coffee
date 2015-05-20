initializeStoreInjections = (registry) ->
  registry.injection 'controller', 'store', 'store:-cw'
  registry.injection 'route', 'store', 'store:-cw'

`export default initializeStoreInjections`
