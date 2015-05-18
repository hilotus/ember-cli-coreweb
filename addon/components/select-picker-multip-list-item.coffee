`import Ember from 'ember'`

SelectPickerMultipListItemComponent = Ember.Component.extend
  tagName: 'li'
  classNames: ['result']

  isFocus: false
  content: null

  mouseEnter: ->
    @set 'isFocus', true

  mouseLeave: ->
    @set 'isFocus', false

  # checkbox is selected
  # k: value
  # v: undefined, true, false
  value: Ember.computed
    get: ->
      false

    set: (key, newValue) ->
      selection = @get('parentView.selection')
      if selection && @content
        if newValue
          @get('parentView.selection').pushObject(@content) if !selection.contains(@content)
        else
          @get('parentView.selection').removeObject(@content) if selection.contains(@content)
      newValue

  didInsertElement: ->
    self = @
    Ember.run.later(->
      selection = self.get("parentView.selection")
      content = self.get("content")
      self.set('value', selection.contains content) if selection && content
    , 500)

`export default SelectPickerMultipListItemComponent`
