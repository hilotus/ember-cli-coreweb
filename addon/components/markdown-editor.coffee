`import Ember from 'ember'`

MarkdownEditorComponent = Ember.Component.extend
  classNameBindings: [':markdown-editor', 'autoHeight:auto-height']

  editor: null
  isEditting: true
  autoHeight: false
  height: 420
  body: ''

  didInsertElement: ->
    @.$('textarea').val @body

    self = @
    Ember.run.schedule 'afterRender', ->
      self.editor = CodeMirror.fromTextArea self.$('textarea')[0],
        mode: 'gfm'
        lineNumbers: false
        matchBrackets: true
        lineWrapping: true
        theme: 'base16-light'
        extraKeys: {"Enter": "newlineAndIndentContinueMarkdownList"}

      self.editor.setSize 'auto', self.height unless self.autoHeight
      self.editor.on 'change', (instance) ->
        self.set 'body', instance.getValue()

  actions:
    toggle: ->
      @.$('.CodeMirror').css 'display', if @isEditting then 'none' else 'block'
      @.set 'isEditting', !@isEditting

`export default MarkdownEditorComponent`
