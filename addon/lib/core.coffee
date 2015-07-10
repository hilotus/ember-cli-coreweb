`import Ember from 'ember'`

`import 'ember-cli-coreweb/lib/ember-initializer'`

`import Adapter from './adapter'`
`import AdapterParse from './adapter-parse'`
`import Store from './store'`
`import Model from './model'`
`import Calendar from './calendar'`

CW = Ember.Namespace.create
  VERSION: '1.0.0'
  Adapter: Adapter
  AdapterParse: AdapterParse
  Store: Store
  Model: Model
  Calendar: Calendar

if Ember.libraries
  Ember.libraries.registerCoreLibrary 'CoreWeb', CW.VERSION

`export default CW`
