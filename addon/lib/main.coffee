`import CW from './core'`

Ember.defineProperty CW, 'normalizeModelName',
  enumerable: true,
  writable: false,
  configurable: false,
  value: (modelName) ->
    Ember.String.dasherize modelName

Ember.lookup.CW = CW

`export default CW`
