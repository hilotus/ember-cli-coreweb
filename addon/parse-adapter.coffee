`import Ember from 'ember'`
`import parseAjax from './parse-ajax'`
`import adapter from './adapter-template'`

parseAdapter = Ember.$.extend Ember.copy(adapter), parseAdapter
parseAdapter.getEndPoint = (modelTypeKey) ->
  if modelTypeKey.match(/User/) then 'users' else modelTypeKey

parseAdapter = Ember.$.extend parseAdapter, parseAjax
ParseAdapter = Ember.Object.extend parseAdapter

`export default ParseAdapter`
