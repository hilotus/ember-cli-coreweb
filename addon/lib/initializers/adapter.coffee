`import Adapter from 'ember-cli-coreweb/lib/adapter'`
`import AdapterParse from 'ember-cli-coreweb/lib/adapter-parse'`

initializeAdapter = (registry) ->
  registry.register 'adapter:-cw', Adapter
  registry.register 'adapter:-parse', AdapterParse

`export default initializeAdapter`
