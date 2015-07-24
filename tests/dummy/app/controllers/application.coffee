`import Ember from 'ember'`

ApplicationController = Ember.Controller.extend
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

      todo.save().then((record) ->
        self.model.pushObject record
      ).catch((reason) ->
        self.am 'Errors occur', reason.error, 'error'
      ).finally ->
        self.set 'addValue', ''

    del: (todo) ->
      self = @
      todo.delete().then(->
        self.model.removeObject todo
      ).catch((reason) ->
        self.am 'Errors occur', reason.error, 'error'
      )

`export default ApplicationController`
