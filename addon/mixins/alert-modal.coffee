`import Ember from 'ember'`

# Use in Application Controller.
AlertModalMixin = Ember.Mixin.create
  type: 'check'
  buttons: []
  title: ''
  message: ''
  isHidden: true

  actions:
    showAlert: (title, message, type, buttons) ->
      @setProperties
        title: title
        message: message
        type: type
        buttons: buttons
        isHidden: false

    closeAlert: ->
      @setProperties
        title: ''
        message: ''
        type: ''
        buttons: []
        isHidden: true

`export default AlertModalMixin`
