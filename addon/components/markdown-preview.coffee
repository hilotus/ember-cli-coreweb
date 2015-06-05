`import Ember from 'ember'`

MarkdownPreviewComponent = Ember.Component.extend
  classNames: ['markdown-preview']

  body: ""

  __renderView: Ember.observer('body', ->
    @set 'body', @body.replace /<equation>((.*?\n)*?.*?)<\/equation>/ig, (a, b) ->
      '<img src="http://latex.codecogs.com/png.latex?' + encodeURIComponent(b) + '" />'

    out = @.$()[0]
    old = out.cloneNode(true)
    out.innerHTML = @container.lookup('utils:md').render(@body)
    # emojify.run(out);

    allold = old.getElementsByTagName("*");
    return if allold is undefined

    allnew = out.getElementsByTagName("*");
    return if allnew is undefined

    i = 0
    max = max = Math.min allold.length, allnew.length
    while i < max
      if !allold[i].isEqualNode(allnew[i])
        out.scrollTop = allnew[i].offsetTop
        return
      i++
  )

  didInsertElement: ->
    @__renderView()

`export default MarkdownPreviewComponent`
