`import Ember from 'ember'`;

ParseAjax = Ember.Mixin.create
  applicationId: ''
  restApiKey: ''
  host: 'https://api.parse.com'
  namespace: '1'
  classesPath: 'classes'

  sessionToken: ''

  ajax: (url, type, options={}) ->
    self = this
    new Ember.RSVP.Promise (resolve, reject) ->
      hash = self.ajaxOptions url, type, options
      hash.success = (json) ->
        Ember.run null, resolve, json
      hash.error = (jqXHR) ->
        Ember.run null, reject, self.ajaxError(jqXHR)

      Ember.$.ajax hash

  ajaxOptions: (url, type, options={}) ->
    self = this
    options.url = @buildUrl(url)
    options.type = type.toUpperCase()
    options.dataType = 'json'
    # options.xhrFields = { 'withCredentials': true };

    if options.data and options.type isnt 'GET'
      options.contentType = 'application/json; charset=utf-8'
      options.data = JSON.stringify(options.data)

    options.beforeSend = (xhr) ->
      xhr.setRequestHeader 'X-Parse-Application-Id', self.get('applicationId')
      xhr.setRequestHeader 'X-Parse-REST-API-Key', self.get('restApiKey')
      ###
      * 1. Validating Session Tokens / Retrieving Current User
      * 2. Updating Users
      * 3. Deleting Users
      ###
      if (options.url.match(/users\/me/) and options.type is 'GET') or (options.type.match(/PUT|DELETE/) and options.url.match(/users/))
        xhr.setRequestHeader 'X-Parse-Session-Token', self.get('sessionToken')
    options

  ajaxError: (jqXHR) ->
    reason = jqXHR.responseJSON
    if Ember.isEmpty(reason) or $.isEmptyObject(reason)
      reason = {error: "#{jqXHR.statusText}, (#{jqXHR.status})"}
    reason

  buildUrl: (url) ->
    if url.match(/users|Password|login|batch/)
      "#{@host}/#{@namespace}/#{url}"
    else
      "#{@host}/#{@namespace}/#{@classesPath}/#{url}"

  buildBatchPath: (typeKey, id) ->
    "/#{@namespace}/#{@classesPath}/#{typeKey}#{if Ember.isBlank(id) then "" else "/#{id}"}"

`export default ParseAjax`
