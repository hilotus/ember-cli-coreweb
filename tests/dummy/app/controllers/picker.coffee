`import Ember from 'ember'`

PickerController = Ember.Controller.extend
  data: Ember.computed ->
    Ember.A(
      [
        Ember.Object.create(id: '111', name: '111')
        Ember.Object.create(id: '222', name: '222')
        Ember.Object.create(id: '333', name: '333')
        Ember.Object.create(id: '444', name: '444')
        Ember.Object.create(id: '555', name: '555')
        Ember.Object.create(id: '666', name: '666')
      ]
    )

  mutilSelection: []
  selection: []

`export default PickerController`
