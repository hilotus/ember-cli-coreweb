`import Ember from 'ember'`
`import ajax from './ajax-template'`

parseAjax =
  sessionToken: ''

  ajaxOptions: (url, type, options={}) ->
    self = @
    options.url = @buildUrl(url)
    options.type = type.toUpperCase()
    options.dataType = 'json'

    if options.data and options.type isnt 'GET'
      options.contentType = 'application/json; charset=utf-8'
      options.data = JSON.stringify(options.data)

    options.beforeSend = (xhr) ->
      xhr.setRequestHeader 'X-Parse-Application-Id', self.get('api.applicationId')
      xhr.setRequestHeader 'X-Parse-REST-API-Key', self.get('api.restApiKey')
      ###
      * 1. Validating Session Tokens / Retrieving Current User
      * 2. Updating Users
      * 3. Deleting Users
      ###
      if (options.url.match(/users\/me/) and options.type is 'GET') or (options.type.match(/PUT|DELETE/) and options.url.match(/users/))
        xhr.setRequestHeader 'X-Parse-Session-Token', self.get('sessionToken')
    options

  buildUrl: (url) ->
    if url.match(/users|Password|login|batch/)
      "#{@api.host}/#{@api.namespace}/#{url}"
    else
      "#{@api.host}/#{@api.namespace}/#{@api.classesPath}/#{url}"

parseAjax = Ember.$.extend Ember.copy(ajax), parseAjax

`export default parseAjax`
