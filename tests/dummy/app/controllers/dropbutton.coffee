`import Ember from 'ember'`

DropbuttonController = Ember.Controller.extend
  breadCrumb: 'DropButton'

  optionsPrimary: Ember.computed ->
    self = @
    Ember.A(
      [
        Ember.Object.create label: 'Button1', target: self, icon: 'fa-user', primary: true, action: ->
          alert('Button1')
        Ember.Object.create label: 'Button2', target: self, action: ->
          alert('Button2')
        Ember.Object.create label: 'Button3', target: self, action: ->
          alert('Button3')
      ]
    )

  options: Ember.computed ->
    self = @
    Ember.A(
      [
        Ember.Object.create label: 'Button1', target: self, action: ->
          alert('Button1')
        Ember.Object.create label: 'Button2', target: self, icon: 'fa-user', action: ->
          alert('Button2')
        Ember.Object.create label: 'Button3', target: self, action: ->
          alert('Button3')
      ]
    )

`export default DropbuttonController`
