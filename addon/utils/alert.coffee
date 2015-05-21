Alert = ->
  @alert = (title, message, type) ->
    appCtrl = @container.lookup 'controller:application'
    appCtrl.send 'showAlert', title, message, type

Alert.create = ->
  new Alert

`export default Alert`
