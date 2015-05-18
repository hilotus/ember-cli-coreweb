`import Ember from 'ember'`

AlertModalComponent = Ember.Component.extend
  classNameBindings: [':modal', 'isHidden:hidden']
  isHidden: true

  # check(default), error, warn, info
  type: 'check'
  alertType: Ember.computed 'type', ->
    "alert-#{@type}"

  # Ember.Object.create(label: 'OK', icon: fs-user, action: ..., target: self)
  buttons: []
  title: ''
  message: ''

  rightButton: Ember.computed 'buttons', ->
    if @buttons and @buttons.length > 0
      @buttons[0]
    else
      self = @
      Ember.Object.create
        label: 'OK'
        target: self
        action: ->
          @set 'isHidden', true


  leftButton: Ember.computed 'buttons', ->
    if @buttons and @buttons.length > 1 then @buttons[1] else null

`export default AlertModalComponent`
