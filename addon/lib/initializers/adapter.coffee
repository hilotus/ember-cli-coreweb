`import Adapter from 'ember-cli-coreweb/lib/adapter'`

initializeAdapter = (registry) ->
  registry.register 'adapter:-cw', Adapter

`export default initializeAdapter`
