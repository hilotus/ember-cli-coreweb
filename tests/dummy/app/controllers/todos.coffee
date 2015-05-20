`import Ember from 'ember'`
`import Todo from 'dummy/models/todo'`

TodosController = Ember.Controller.extend
  breadCrumb: 'CW Frameworks'
  addValue: ''

  actions:
    add: ->
      self = @
      todo = new Todo
      todo.setVals
        title: @addValue
        isCompleted: false

      todo.save().then((record) ->
        self.model.pushObject record
      ).catch((reason) ->
        self.container.lookup('controller:application').send 'showAlert', 'Errors occur', reason.error, 'error'
      ).finally ->
        self.set 'addValue', ''

`export default TodosController`
