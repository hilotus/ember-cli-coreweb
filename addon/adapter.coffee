`import Ember from 'ember'`
`import ajax from './ajax-template'`
`import adapter from './adapter-template'`

Adapter = Ember.Object.extend Ember.$.extend adapter, ajax

`export default Adapter`
