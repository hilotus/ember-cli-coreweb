`import Ember from 'ember'`

AlertModalComponent = Ember.Component.extend
  classNameBindings: [':modal', 'isActive:modal-active']
  isActiveBinding: 'content.isActive'
  typeBinding: 'content.type'
  buttonsBinding: 'content.buttons'
  titleBinding: 'content.title'
  messageBinding: 'content.message'

  alertType: Ember.computed 'type', ->
    if @type then "alert-#{@type}" else "alert-check"

  # type: check(default), error, warn, info
  # button: Ember.Object.create(label: 'OK', leftIcon: fs-user, rightIcon: fs-user, action: ..., target: self)
  content: null

  rightButton: Ember.computed 'buttons', ->
    if @buttons and @buttons.length > 0
      @buttons[0]
    else
      Ember.Object.create label: 'OK'

  leftButton: Ember.computed 'buttons', ->
    if @buttons and @buttons.length > 1 then @buttons[1] else null

`export default AlertModalComponent`
