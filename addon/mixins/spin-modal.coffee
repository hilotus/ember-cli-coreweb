`import Ember from 'ember'`

# Use in Application Controller.
SpinModalMixin = Ember.Mixin.create
  title: ''
  isActive: false

  actions:
    showSpinner: (title) ->
      @set 'isActive', true
      @set 'title', title

    closeSpinner: ->
      @set 'isActive', false
      @set 'title', ''

`export default SpinModalMixin`
