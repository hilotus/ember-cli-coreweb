`import Ember from 'ember'`

ajax =
  # You can config api json in enviroment
  # CW:
  #   parseApi: {}
  #   api: {}

  # This methods must be override.
  # Maybe you can use ic-ajax.
  ajax: (url, type, options) ->
    self = @
    return new Ember.RSVP.Promise (resolve, reject) ->
      hash = self.ajaxOptions url, type, options

      hash.success = (json) ->
        Ember.run null, resolve, json

      hash.error = (jqXHR) ->
        Ember.run null, reject, self.ajaxError(jqXHR)

      Ember.$.ajax(hash)

  ajaxOptions: (url, type, options={}) ->
    options.url = @buildUrl url
    options.type = type.toUpperCase()
    options.dataType = 'json'
    options.xhrFields = { 'withCredentials': true }

    if options.data or options.type isnt 'GET'
      options.contentType = 'application/json; charset=utf-8'
      options.data = JSON.stringify options.data

    options

  # error json format:
  #   {code: xxx, message: xxx}
  #   {code: xxx, error: xxx}
  ajaxError: (jqXHR) ->
    result = jqXHR.responseJSON
    return new Ember.Error(jqXHR.status + jqXHR.statusText) unless result
    new Ember.Error(result.message or result.error)

  buildUrl: (url) ->
    "#{@api.host}/#{@api.namespace}/#{url}"

`export default ajax`
