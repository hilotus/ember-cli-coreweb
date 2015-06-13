`import Ember from 'ember'`

# Use in Application Controller.
AlertModalMixin = Ember.Mixin.create
  # ok right button label, default is 'OK'
  okButtonLabel: 'OK'
  # cancel right button label, default is 'OK'
  cancelButtonLabel: 'Cancel'

  alertContent: null

  init: ->
    @_super()
    @set 'alertContent', {}
    @set 'alertContent.type', 'check'
    @set 'alertContent.buttons', []
    @set 'alertContent.title', ''
    @set 'alertContent.message', ''
    @set 'alertContent.isActive', false

  showAlertModal: (title, message, type, buttons) ->
    @set 'alertContent.type', type
    @set 'alertContent.buttons', buttons
    @set 'alertContent.title', title
    @set 'alertContent.message', message
    @set 'alertContent.isActive', true

  closeAlertModal: ->
    @set 'alertContent.isActive', false
    @set 'alertContent.type', 'check'
    @set 'alertContent.buttons', []
    @set 'alertContent.title', ''
    @set 'alertContent.message', ''

  actions:
    showAlert: (title, message, type) ->
      button =
        label: @get('okButtonLabel')
        target: @
        action: @closeAlertModal

      @showAlertModal title, message, type, [button]

    showConfirm: (title, message, type, okButton) ->
      cancelButton =
        label: @get('cancelButtonLabel')
        target: @
        action: @closeAlertModal

      @showAlertModal title, message, type, [okButton, cancelButton]

`export default AlertModalMixin`
