`import Ember from 'ember'`

CWButtonComponent = Ember.Component.extend
  tagName: 'button'
  classNameBindings: [':button', 'colorClass', 'shapeClass', 'customClass']
  customClass: ''
  colorClass: Ember.computed 'color', ->
    if @color then "button-#{@color}" else ''
  shapeClass: Ember.computed 'shape', ->
    if @shape then "button-#{@shape}" else ''

  attributeBindings: ['disabled']
  disabled: Ember.computed 'isDisabled', ->
    @isDisabled

  # default is ''
  # options: blue, red, green
  color: ''
  # default is ''
  # options: round, left, right
  shape: ''
  isDisabled: false

  label: ''
  leftIcon: null
  rightIcon: null
  action: null
  # if target is null, the action is in actions of controller: {},
  # otherwise, the action is in target.
  target: null

  click: (event) ->
    event.preventDefault()
    unless @isDisabled
      if Ember.isBlank @target
        @sendAction('action', @get('context'))
      else
        @action.call(@target)

`export default CWButtonComponent`
