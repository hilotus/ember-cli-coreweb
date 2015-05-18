`import Ember from 'ember'`

PickerController = Ember.Controller.extend
  breadCrumb: 'Picker'

  init: ->
    @tmpData = [
      Ember.Object.create(id: '111', name: '111')
      Ember.Object.create(id: '222', name: '222')
      Ember.Object.create(id: '333', name: '333')
      Ember.Object.create(id: '444', name: '444')
      Ember.Object.create(id: '555', name: '555')
      Ember.Object.create(id: '666', name: '666')
    ]

  data: Ember.computed ->
    @tmpData

  mutilSelection: Ember.computed ->
    @tmpData.filter (item) ->
      item.id is '333'

  selection: []

`export default PickerController`
