`import Ember from 'ember'`
`import BreadCrumbsMixin from 'ember-cli-coreweb/mixins/bread-crumbs'`
`import AlertModalMixin from 'ember-cli-coreweb/mixins/alert-modal'`

ApplicationController = Ember.Controller.extend BreadCrumbsMixin, AlertModalMixin,
  breadcrumbHome: Ember.computed ->
    Ember.Object.create
      route: 'application'
      name: 'Home'

  okButtonLabel: 'OK'
  okButtonIcon: ''
  cancelButtonLabel: 'Cancel'
  cancelButtonIcon: ''

  alertButton: Ember.computed ->
    Ember.Object.create
      label: 'Alert'
      target: @
      action: ->
        @am 'Alert Title', 'Alert Message Alert Message Alert Message Alert Message Alert Message Alert Message Alert MessageAlert Message', 'check'

  confirmButton: Ember.computed ->
    Ember.Object.create
      label: 'Confirm'
      target: @
      action: ->
        button = Ember.Object.create
          label: 'Confirm11'
          target: @
          action: ->
            alert("I'm in application controller.")
            @closeAlertModal()

        @cm 'Confirm Title', 'Confirm Message', 'warn', button

`export default ApplicationController`
