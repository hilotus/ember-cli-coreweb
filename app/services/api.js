import Ember from 'ember';
import icajax from 'ember-cli-coreweb/ic-ajax';
import pluralize from 'ember-cli-coreweb/pluralize';

var Parent = Ember.Service || Ember.Object;

export default Parent.extend({
  options: {
    host: 'http://localhost:3000',
    namespace: '1'
  },

  // Parse api session
  sessionToken: null,

  query: function (modelTypeKey, id) {
    var settings = this.buildArgs(id);
    settings.type = 'GET';
    settings.url = this.buildUrl(modelTypeKey, id);

    return this.sendRequest(settings);
  },

  post: function (modelTypeKey, data) {
    var settings = this.buildArgs(data);
    settings.type = 'POST';
    settings.url = this.buildUrl(modelTypeKey);

    return this.sendRequest(settings);
  },

  put: function (modelTypeKey, id, data) {
    var settings = this.buildArgs(data);
    settings.type = 'PUT';
    settings.url = this.buildUrl(modelTypeKey, id);

    return this.sendRequest(settings);
  },

  delete: function (modelTypeKey, id) {
    var settings = this.buildArgs();
    settings.type = 'DELETE';
    settings.url = this.buildUrl(modelTypeKey, id);

    return this.sendRequest(settings);
  },

  /*
    Send ajax request with ic-ajax.
  */
  sendRequest: function (settings) {
    return icajax(settings).then(function (res) {
      return Ember.RSVP.resolve(res);
    }).catch(function (res) {
      var err, json;

      if (res.jqXHR) {
        json = res.jqXHR.responseJSON;
        if (!Ember.$.isPlainObject(json)) {
          err = new Error(res.jqXHR.status + ': ' + res.jqXHR.statusText);
        } else {
          err = new Error(JSON.stringify(json));
        }
      } else if (res instanceof Error) {  // res is a Error;
        err = res;
      } else {
        err = new Error('Unkonw Error!');
      }

      return Ember.RSVP.reject(err);
    });
  },

  /*
    modelTypeKey: user / post / comment ...
    id: data (request body) / options (ajax) / id (string)
  */
  buildUrl: function (modelTypeKey, id) {
    var path, ops = this.options;

    if (ops.applicationId) {  // Parse api
      var isUserApi = modelTypeKey.match(/user|users|requestPasswordReset|login|logout/);

      if (isUserApi) {  // User api
        path = modelTypeKey === 'user' ? 'users' : modelTypeKey;
      } else {  // other Object api
        path = modelTypeKey.classify();
      }

      if (typeof id === 'string') {
        path = path + '/' + id;
      }

      if (isUserApi) {
        return ops.host + '/' + ops.namespace + '/' + path;
      } else {
        return ops.host + '/' + ops.namespace + '/' + ops.classesPath + '/' + path;
      }
    } else {  // common server-backed api
      path = pluralize(modelTypeKey);

      if (typeof id === 'string') {
        path = path + '/' + id;
      }

      return ops.host + '/' + ops.namespace + '/' + path;
    }
  },

  /*
    get: data --> query string
    post / put: data --> request body
  */
  buildArgs: function (data) {
    var ops = this.options,
      self = this,
      settings = {};

    if (ops.applicationId) {  // Parse api
      settings.beforeSend = function (xhr) {
        xhr.setRequestHeader('X-Parse-Application-Id', self.get('options.applicationId'));
        xhr.setRequestHeader('X-Parse-REST-API-Key', self.get('options.restApiKey'));

        /*
        * 1. Validating Session Tokens / Retrieving Current User / logout
        * 2. Updating Users
        * 3. Deleting Users
        */
        if (settings.url.match(/users\/me/)
            || (settings.url.match(/users/) && settings.type.match(/PUT|DELETE/))
            || (settings.url.match(/logout/) && settings.type.match(/POST/))) {
          xhr.setRequestHeader('X-Parse-Session-Token', self.get('sessionToken'));
        }
      };
    } else {  // common server-backed api
    }

    if (!Ember.$.isEmptyObject(data)) {
      settings.data = data;
    }

    return settings;
  }
});
