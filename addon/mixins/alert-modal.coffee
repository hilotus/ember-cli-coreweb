`import Ember from 'ember'`

# Use in Application Controller.
AlertModalMixin = Ember.Mixin.create
  type: 'check'
  buttons: []
  title: ''
  message: ''
  isHidden: true

  # ok right button label, default is 'OK'
  okButtonLabel: 'OK'
  okButtonIcon: ''
  # cancel right button label, default is 'OK'
  cancelButtonLabel: 'Cancel'
  cancelButtonIcon: ''

  showAlertModal: (title, message, type, buttons) ->
    @setProperties
      title: title
      message: message
      type: type
      buttons: buttons
      isHidden: false

  closeAlertModal: ->
    @set 'isHidden', true
    @setProperties
      title: ''
      message: ''
      type: ''
      buttons: []

  actions:
    showAlert: (title, message, type) ->
      button = Ember.Object.create
        label: @okButtonLabel
        icon: @okButtonIcon
        target: @
        action: ->
          @closeAlertModal()

      @showAlertModal title, message, type, [button]

    showConfirm: (title, message, type, okButton) ->
      cancelButton = Ember.Object.create
        label: @cancelButtonLabel
        icon: @cancelButtonIcon
        target: @
        action: ->
          @closeAlertModal()

      @showAlertModal title, message, type, [okButton, cancelButton]

`export default AlertModalMixin`
