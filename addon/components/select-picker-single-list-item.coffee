`import Ember from 'ember'`

SelectPickerSingleListItemComponent = Ember.Component.extend
  tagName: 'li'
  classNameBindings: [':result', ':not-multiple', 'isMouseEnter:highlighted', 'isSelected:selected']

  isMouseEnter: false
  content: null

  mouseEnter: ->
    @set 'isMouseEnter', true

  mouseLeave: ->
    @set 'isMouseEnter', false

  isSelected: Ember.computed 'parentView.selection.id', ->
    @content && @get('content.id') is @get('parentView.selection.id')

  click: ->
    @set 'parentView.isActive', false
    @set 'parentView.selection', if @get('isSelected') then null else @content

`export default SelectPickerSingleListItemComponent`
