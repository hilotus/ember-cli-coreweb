`import Ember from 'ember'`

ButtonController = Ember.Controller.extend
  breadCrumb: 'Button'

  regularContent: Ember.computed ->
    self = @
    Ember.Object.create label: 'Regular', rightIcon: 'fa-user', action: ->

  hugeContent: Ember.computed ->
    self = @
    Ember.Object.create label: 'Huge', action: ->

  largeContent: Ember.computed ->
    self = @
    Ember.Object.create label: 'Large', action: ->

  smallContent: Ember.computed ->
    self = @
    Ember.Object.create label: 'Small', leftIcon: 'fa-user', action: ->

  tinyContent: Ember.computed ->
    self = @
    Ember.Object.create label: 'Tiny', action: ->

  buttonContent: Ember.computed ->
    self = @
    Ember.Object.create label: 'Button', action: ->

  leftIconButtonContent: Ember.computed ->
    self = @
    Ember.Object.create label: 'Button', leftIcon: 'fa-user', action: ->

  rightIconButtonContent: Ember.computed ->
    self = @
    Ember.Object.create label: 'Button', rightIcon: 'fa-user', action: ->

`export default ButtonController`
