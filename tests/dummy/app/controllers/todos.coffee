`import Ember from 'ember'`
`import Todo from '../models/todo'`

TodosController = Ember.Controller.extend
  addValue: ''

  model: []

  buttonDisabled: Ember.computed 'addValue', ->
    !@addValue

  actions:
    add: ->
      self = @
      todo = new Todo
      todo.setVals
        title: @addValue
        isCompleted: false

      todo.save().then ->
        self.model.pushObject todo
        self.set 'addValue', ''

    del: (todo) ->
      self = @
      todo.delete().then ->
        self.model.removeObject todo

    saveChanges: () ->
      @store.commitChanges()

`export default TodosController`
