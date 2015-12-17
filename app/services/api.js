import Ember from 'ember';
import icajax from 'ember-cli-coreweb/ic-ajax';
import { CustomError } from 'ember-cli-coreweb/error';

var Parent = Ember.Service || Ember.Object;

export default Parent.extend({
  /*
    api: {
      // required
      host: 'http://localhost:9292',
      namespace: '1',
      // optional, (third-part. such as 'parse api')
      parse: true,
      applicationId: 'xxx',
      restApiKey: 'xxx',
      classPath: 'classes'
    }
  */
  options: null,

  // session token string after user login.
  sessionToken: null,

  query: function (path, data) {
    return this.sendRequest('GET', path, data);
  },

  post: function (path, data) {
    return this.sendRequest('POST', path, data);
  },

  put: function (path, data) {
    return this.sendRequest('PUT', path, data);
  },

  delete: function (path) {
    return this.sendRequest('DELETE', path);
  },

  /*
    Send ajax request with ic-ajax.
      - method: get, post, put, delete
      - path: api path
      - data: query string or
  */
  sendRequest: function () {
    var method = arguments[0],
      path = arguments[1],
      data = arguments[2],
      ops = this.options,
      settings = {};

    if (Ember.$.isPlainObject(data) && !Ember.$.isEmptyObject(data)) {
      settings.data = data;
    }
    settings.url = ops.host + '/' + ops.namespace + '/' + path;
    settings.type = method;
    settings._path = path;

    // Parse api, before send
    if (ops.parse) {
      settings.beforeSend = function (xhr) {
        xhr.setRequestHeader('X-Parse-Application-Id', this.get('options.applicationId'));
        xhr.setRequestHeader('X-Parse-REST-API-Key', this.get('options.restApiKey'));

        /**
          Logging In should add "X-Parse-Revocable-Session: 1" header,
          even if your app has "Require Revocable Sessions" turned off,
          else this header is optional.
        **/
        if (settings.url.match(/login/)) {
          xhr.setRequestHeader('X-Parse-Revocable-Session', 1);
        }

        /*
        * 1. Validating Session Tokens / Retrieving Current User / logout
        * 2. Updating Users
        * 3. Deleting Users
        */
        if (settings.url.match(/users\/me/)
            || (settings.url.match(/users/) && settings.type.match(/PUT|DELETE/))
            || (settings.url.match(/logout/) && settings.type.match(/POST/))) {
          xhr.setRequestHeader('X-Parse-Session-Token', this.get('sessionToken'));
        }
      }.bind(this);
    }

    return icajax(settings).then(function (res) {
      return Ember.RSVP.resolve(res);
    }).catch(function (res) {
      var err, json;

      json = res.response || res.jqXHR.responseJSON;

      if (res instanceof Error) {
        err = new CustomError(res.message);
        err.stack = res.stack;
      } else if (Ember.$.isPlainObject(json) && !Ember.$.isEmptyObject(json)) {
        // example parse api result: {"code":101,"error":"invalid login parameters"}
        err = new CustomError(json.error, json.code, true);
      } else {
        err = new CustomError(res.jqXHR.status + ': ' + res.jqXHR.statusText, 522);
      }

      return Ember.RSVP.reject(err);
    });
  }
});
