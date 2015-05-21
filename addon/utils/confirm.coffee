Confirm = ->
  @confirm = (title, message, type, okButton) ->
    appCtrl = @container.lookup 'controller:application'
    appCtrl.send 'showConfirm', title, message, type, okButton

Confirm.create = ->
  new Confirm

`export default Confirm`
