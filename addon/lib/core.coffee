`import Ember from 'ember'`

`import 'ember-cli-coreweb/lib/ember-initializer'`

`import Adapter from './adapter'`
`import Store from './store'`
`import Model from './model'`

CW = Ember.Namespace.create
  VERSION: '1.0.0'
  Adapter: Adapter
  Store: Store
  Model: Model

if Ember.libraries
  Ember.libraries.registerCoreLibrary 'CoreWeb', CW.VERSION

`export default CW`
