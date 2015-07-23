`import Ember from 'ember'`

AlertModalComponent = Ember.Component.extend
  classNameBindings: [':modal', 'content.isActive:modal-active:hidden']

  alertType: Ember.computed 'content.type', ->
    if @get('content.type') then "alert-#{@get('content.type')}" else "alert-check"

  # type: check(default), error, warn, info
  # button: Ember.Object.create(label: 'OK', action: function, target: self)
  content: null

  rightButton: Ember.computed 'content.buttons', ->
    if @get('content.buttons') and @get('content.buttons.length') > 0
      @get('content.buttons')[0]
    else
      { label: 'OK' }

  leftButton: Ember.computed 'content.buttons', ->
    if @get('content.buttons') and @get('content.buttons.length') > 1 then @get('content.buttons')[1] else null

`export default AlertModalComponent`
