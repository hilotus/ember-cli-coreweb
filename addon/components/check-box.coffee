`import Ember from 'ember'`

CheckBoxComponent = Ember.Component.extend
  classNameBindings: [':check-box', 'isEnabled:enabled:disabled', 'value:selected', 'isFocus:focus'],
  isEnabled: true
  isFocus: false
  value: false
  text: ""

  toggleOnValue: true,
  toggleOffValue: false,
  __toggleValue: ->
    isOn = @value is @toggleOnValue
    @set 'value', if isOn then @toggleOffValue else @toggleOnValue

  click: ->
    return false unless @isEnabled
    @__toggleValue()

  focusIn: ->
    @set 'isFocus', true if @isEnabled

  focusOut: ->
    @set 'isFocus', false if @isEnabled

  keyDown: (event) ->
    return false unless @isEnabled
    @__toggleValue() if event.which is 13 or event.which is 32

`export default CheckBoxComponent`
