`import Ember from 'ember'`

BreadCrumbsComponent = Ember.Component.extend
  tagName: 'ol'
  classNames: ['breadcrumb']

  breadcrumbs: []
  breadcrumbHome: null

`export default BreadCrumbsComponent`
