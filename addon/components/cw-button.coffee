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

  # Ember.Object.create(label: 'OK', icon: fs-user, action: ..., target: self)
  content: null

  click: ->
    unless @isDisabled
      if @content and $.isFunction(@content.action)
        @content.action.call(@content.target)

`export default CWButtonComponent`
