`import Ember from 'ember'`

DropButtonComponent = Ember.Component.extend
  classNameBindings: [':button-dropdown', 'isDropUp:dropup', 'isOpen:open']
  isDropUp: false
  # open the dropmenu
  isOpen: false

  attributeBindings: ['tabindex', 'style']
  tabindex: 0
  style: Ember.computed ->
    Ember.String.htmlSafe 'outline:none;'

  # default is actions
  label: 'Actions'

  # options: [
  #   Ember.Object.create({ label: 'Save', action: 'save', target: self, leftIcon: fs-user, rightIcon: fs-user }),
  #   Ember.Object.create({ label: 'Delete', target: self, action: delete' }),
  #   Ember.Object.create({ label: 'Edit', target: self, action: 'edit' })
  # ]
  # Or with an primary.
  # options: [
  #   Ember.Object.create({ label: 'Save', target: self, action: 'save', primary: true }),
  #   Ember.Object.create({ label: 'Delete', target: self, action: 'delete' }),
  #   Ember.Object.create({ label: 'Edit', target: self, action: 'edit' })
  # ]
  options: []

  primaryAction: Em.computed 'options', ->
    @get('options').findBy 'primary', true

  optionsWithoutPrimaryAction: Ember.computed.filter 'options', (option) ->
    return not option.primary

  focusOut: ->
    @set 'isOpen', false

  actions:
    toggle: ->
      @set 'isOpen', !@isOpen

    clickButton: (button) ->
      if button and $.isFunction(button.action)
        button.action.call(button.target)
      @set 'isOpen', false

`export default DropButtonComponent`
