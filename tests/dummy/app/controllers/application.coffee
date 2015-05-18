`import Ember from 'ember'`
`import BreadCrumbs from 'ember-cli-coreweb/mixins/bread-crumbs'`
`import AlertModal from 'ember-cli-coreweb/mixins/alert-modal'`

ApplicationController = Ember.Controller.extend BreadCrumbs, AlertModal,
  breadcrumbHome: Ember.computed ->
    Ember.Object.create
      route: 'application'
      name: 'Home'

  alertButton: Ember.computed ->
    self = @
    Ember.Object.create
      label: 'Show Alert'
      target: self
      action: ->
        @send 'showAlert', 'Title', 'Message', 'check'

`export default ApplicationController`
