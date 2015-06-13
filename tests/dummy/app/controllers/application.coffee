`import Ember from 'ember'`
`import BreadCrumbsMixin from 'ember-cli-coreweb/mixins/bread-crumbs'`
`import AlertModalMixin from 'ember-cli-coreweb/mixins/alert-modal'`
`import SpinModalMixin from 'ember-cli-coreweb/mixins/spin-modal'`

ApplicationController = Ember.Controller.extend BreadCrumbsMixin, AlertModalMixin, SpinModalMixin,
  breadcrumbHome: Ember.computed ->
    Ember.Object.create
      route: 'application'
      name: 'Home'

  okButtonLabel: 'OK'
  okButtonIcon: ''
  cancelButtonLabel: 'Cancel'
  cancelButtonIcon: ''

  actions:
    alertModal: ->
      @am 'Alert Title', 'Alert Message Alert Message Alert Message Alert Message Alert Message Alert Message Alert MessageAlert Message', 'check'

    confirmModal: ->
      button =
        label: 'Confirm'
        target: @
        action: ->
          alert("I'm in application controller.")
          @closeModal()

      @cm 'Confirm Title', 'Confirm Message', 'warn', button

    spinModal: ->
      @spin 'Loading...'
      Ember.run.later @, ->
        @closeSpinner()
      , 2000

`export default ApplicationController`
