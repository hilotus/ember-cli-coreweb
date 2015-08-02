`import Ember from 'ember'`

`import Adapter from './adapter'`
`import ParseAdapter from './parse-adapter'`
`import Store from './store'`
`import Model from './model'`

CW = Ember.Namespace.create
  VERSION: '1.0.0'
  Adapter: Adapter
  ParseAdapter: ParseAdapter
  Store: Store
  Model: Model

if Ember.libraries
  Ember.libraries.registerCoreLibrary 'CoreWeb', CW.VERSION

Ember.defineProperty CW, 'normalizeModelName',
  enumerable: true,
  writable: false,
  configurable: false,
  value: (modelName) ->
    Ember.String.dasherize modelName

Ember.lookup.CW = CW

`export default CW`
