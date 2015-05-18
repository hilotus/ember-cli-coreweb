`import Ember from 'ember'`

SwitchBoxComponent = Ember.Component.extend
  tagName: 'label'
  classNameBindings: [':switch', 'class']
  class: ''
  value: false

`export default SwitchBoxComponent`
