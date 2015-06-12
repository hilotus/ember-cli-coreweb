`import Ember from 'ember'`

LinkButtonComponent = Ember.Component.extend
  classNameBindings: [':link-button', 'type', 'isDisabled:disabled', 'customClass']

  # huge, large, regular, smaill, tiny
  type: 'regular'
  isDisabled: false
  customClass: ''

  # Ember.Object.create(label: 'OK', leftIcon: fs-user, rightIcon: fs-user, action: ..., target: self)
  content: null

  click: ->
    unless @isDisabled
      if @content and $.isFunction(@content.action)
        @content.action.call(@content.target)

`export default LinkButtonComponent`
