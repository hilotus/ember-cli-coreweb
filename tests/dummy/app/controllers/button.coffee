`import Ember from 'ember'`

ButtonController = Ember.Controller.extend
  breadCrumb: 'Button'

  regularContent: Ember.computed ->
    self = @
    Ember.Object.create label: 'Regular', action: ->

  hugeContent: Ember.computed ->
    self = @
    Ember.Object.create label: 'Huge', action: ->

  largeContent: Ember.computed ->
    self = @
    Ember.Object.create label: 'Large', action: ->

  smallContent: Ember.computed ->
    self = @
    Ember.Object.create label: 'Small', icon: 'fa-user', action: ->

  tinyContent: Ember.computed ->
    self = @
    Ember.Object.create label: 'Tiny', action: ->

  buttonContent: Ember.computed ->
    self = @
    Ember.Object.create label: 'Button', action: ->

`export default ButtonController`
