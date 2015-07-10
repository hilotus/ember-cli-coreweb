`import Ember from 'ember'`

SpinModalComponent = Ember.Component.extend
  classNameBindings: [':spin-modal', 'isActive:active:hidden']
  isActive: false
  title: ''

  isActiveChanged: Ember.observer 'isActive', ->
    Ember.run.schedule 'afterRender', @, ->
      marginHeight = @.$('.spin-modal-container').height() / 2
      marginWidth = @.$('.spin-modal-container').width() / 2
      @.$('.spin-modal-container').css
        'margin-left': "-#{marginWidth}px"
        'margin-top': "-#{marginHeight}px"

`export default SpinModalComponent`
