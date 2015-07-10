`import Ember from 'ember'`

# please specify width in this class
SelectPickerComponent = Ember.Component.extend
  classNameBindings: [":select-picker", "isActive:select-picker-active"]
  isActive: false

  # Custome width
  width: ""

  attributeBindings: ['style']
  style: Ember.computed 'width', ->
    width = if @width.includes('%') then @width else "#{@width}px"
    return new Ember.Handlebars.SafeString "width: #{width}"

  widthChanged: Ember.observer 'width', ->
    @.$().css
      width: (if @width.includes('%') then @width else "#{@width}px")

  # placeholder title
  prompt: ""
  content: []
  isMultiple: false
  keywords: ""
  searchContent: []
  selection: []

  title: Ember.computed 'selection.id', 'selection.length', ->
    if @isMultiple
      if !@selection or @get('selection.length') is 0
        @prompt
      else
        (
          @selection.map (item) ->
            item.get('name')
        ).join(',')
    else
      name = @get('selection.name')
      if name then name else @prompt

  keywordsChanged: Ember.observer 'keywords', ->
    keywords = @keywords
    if keywords
      @set 'searchContent', @content.filter((item) ->
        return (item.get('name') or "").toLowerCase().indexOf(keywords.toLowerCase()) > -1
      )
    else
      @set 'searchContent', @content

  init: ->
    @_super()
    @set 'searchContent', @content

  # rerenser when content is changes, example findByIds.
  # 1. by store nomalize
  contentChanged: Ember.observer 'content.length', ->
    @set 'searchContent', @content
    @rerender()

  didInsertElement: ->
    self = @
    Ember.run.schedule 'afterRender', ->
      $(document).on 'click', {view: self}, (event) ->
        view = event.data.view
        if view.$()
          unless $.contains(view.$()[0], event.target)
            view.set 'isActive', false if view.get('isActive')

  actions:
    toggle: ->
      @set 'isActive', !@isActive
      @.$('.select-picker-search input').focus() if @isActive

`export default SelectPickerComponent`
