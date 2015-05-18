`import Ember from 'ember'`

# Use in ApplicationController.
BreadCrumbsMixin = Ember.Mixin.create
  breadcrumbs: []
  # breadcrumbHome: Ember.computed ->
  #   Ember.Object.create
  #     route: 'dashboard'
  #     name: @t 'header'
  breadcrumbHome: null

  watchCurrentPath: Ember.observer 'currentPath', ->
    @setCrumbs()

  setCrumbs: ->
    crumbs = []
    @breadcrumbs.clear()

    routes = @container.lookup('router:main').get('router.currentHandlerInfos')
    routes.forEach (route, i, arr) ->
      name = route.name
      return if name.indexOf('.index') isnt -1 or name is 'application'

      breadCrumb = route.handler.controller.get('breadCrumb')

      # Example:
      # we use settings/companies as index in settings resource, so we didn't defien breadCrumb
      # in settings controller, and exclude the settings controller's breadCrumb.
      if breadCrumb
        crumb = Ember.Object.create
          route: route.handler.routeName
          name: breadCrumb
          model: null

        # If it's dynamic, you need to push in the model so we can pull out an ID in the link-to
        if route.isDynamic
          crumb.setProperties
            model: route.handler.context
            name: route.handler.context.get('name')

        # Now push it to the crumbs array
        crumbs.pushObject(crumb)

    @set('breadcrumbs', crumbs)

    # Set the last item in the breadcrumb to be active
    if crumbs.length > 0
      @get('breadcrumbs.lastObject').set('active', true)

`export default BreadCrumbsMixin`
