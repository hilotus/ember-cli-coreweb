`import Ember from 'ember'`

LinkButtonComponent = Ember.Component.extend
  classNameBindings: [':link-button', 'type', 'isDisabled:disabled', 'customClass']

  # huge, large, regular, smaill, tiny
  type: 'regular'
  isDisabled: false
  customClass: ''

  label: ''
  leftIcon: null
  rightIcon: null
  action: null
  # if target is null, the action is in actions: {},
  # otherwise, the action is in target.
  target: null

  click: (event) ->
    event.preventDefault()
    unless @isDisabled
      if Ember.isBlank @target
        @sendAction('action', @get('context'))
      else
        @action.call(@target)

`export default LinkButtonComponent`
