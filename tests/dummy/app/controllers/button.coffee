`import Ember from 'ember'`

ButtonController = Ember.Controller.extend
  breadCrumb: 'Button'

  actions:
    save: ->
      alert('cw-button action')

`export default ButtonController`
