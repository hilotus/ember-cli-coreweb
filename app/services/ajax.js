import Ember from 'ember';

var Parent = Ember.Service || Ember.Object;

export default Parent.extend({
  api: {},

  ajax: function(url, type, options) {
    var self = this;
    return new Ember.RSVP.Promise(function(resolve, reject) {
      var hash;
      hash = self.ajaxOptions(url, type, options);
      hash.success = function(json) {
        return Ember.run(null, resolve, json);
      };
      hash.error = function(jqXHR) {
        return Ember.run(null, reject, self.ajaxError(jqXHR));
      };
      return Ember.$.ajax(hash);
    });
  },

  ajaxOptions: function(url, type, options) {
    if (options == null) {
      options = {};
    }

    options.url = url;
    options.type = type.toUpperCase();
    options.dataType = 'json';
    options.xhrFields = { 'withCredentials': true };
    if (options.data || options.type !== 'GET') {
      options.contentType = 'application/json; charset=utf-8';
      options.data = JSON.stringify(options.data);
    }
    return options;
  },

  ajaxError: function(jqXHR) {
    var result = jqXHR.responseJSON;
    if (!result) {
      return new Ember.Error(jqXHR.status + jqXHR.statusText);
    }
    return new Ember.Error(result.message || result.error);
  },

  // Build url by modelTypeKey and id
  buildUrl: function(modelTypeKey, id) {
    var path = !id ? pluralize(modelTypeKey) : pluralize(modelTypeKey) + '/' + id;
    return api.host + api.namespace + '/' + path;
  }
});
