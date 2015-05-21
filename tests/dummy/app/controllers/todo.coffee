`import Ember from 'ember'`

TodoController = Ember.Controller.extend
  doneChanged: Ember.observer 'model.isCompleted', ->
    self = @
    @model.commitChanges().catch((reason) ->
      self.am 'Error Save', reason.error, 'error'
    )

`export default TodoController`
