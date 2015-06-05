`import Ember from 'ember'`

initialize = (registry, application) ->
  languageOverrides =
    js: 'javascript'
    html: 'xml'

  # emojify.setConfig img_dir: 'http://7rf345.com1.z0.glb.clouddn.com/emojify.js/dist/images/base'

  md = markdownit(
    highlight: (code, lang) ->
      lang = languageOverrides[lang] if languageOverrides[lang]
      if lang and hljs.getLanguage(lang)
        try
          return hljs.highlight(lang, code).value
        catch error
      return ''
  ).use(markdownitFootnote)

  application.register 'utils:md', md, {instantiate: false, singleton: true}

MarkdownEditorInitializer =
  nalerte: 'markdown-editor'
  initialize: initialize

`export default MarkdownEditorInitializer`
