import Ember from 'ember';
import CWError from 'ember-cli-coreweb/error';
import pluralize from 'ember-cli-coreweb/pluralize';

var Parent = Ember.Service || Ember.Object;

export default Parent.extend({
  __fixtures__: {},
  api: {},

  sendRequest: function() {
    var settings = this.parseArgs.apply(this, arguments);
    return this.makePromise(settings);
  },

  defineFixture: function(url, fixture) {
    if (fixture.response) {
      fixture.response = JSON.parse(JSON.stringify(fixture.response));
    }
    this.__fixtures__[url] = fixture;
  },

  lookupFixture: function(url) {
    return this.__fixtures__ && this.__fixtures__[url];
  },

  makePromise: function(settings) {
    var self = this;
    return new Ember.RSVP.Promise(function(resolve, reject) {
      var fixture = self.lookupFixture(settings.url);
      if (fixture) {
        if (fixture.textStatus === 'success' || fixture.textStatus == null) {
          return Ember.run.later(null, resolve, fixture);
        } else {
          return Ember.run.later(null, reject, fixture);
        }
      }
      // response, textStatus, jqXHR
      settings.success = function(response) {
        return Ember.run(null, resolve, self.makeSuccess(response));
      };
      // jqXHR, textStatus, errorThrown
      settings.error = function(jqXHR) {
        return Ember.run(null, reject, self.makeError(jqXHR));
      };
      Ember.$.ajax(settings);
    });
  },

  parseArgs: function() {
    var settings = {};
    if (arguments.length === 1) {
      if (typeof arguments[0] === "string") {
        settings.url = arguments[0];
      } else {
        settings = arguments[0];
      }
    } else if (arguments.length === 2) {
      settings = arguments[1];
      settings.url = arguments[0];
    }
    if (settings.success || settings.error) {
      throw new Ember.Error("ajax should use promises, received 'success' or 'error' callback");
    }
    settings.type = (settings.type || 'GET').toUpperCase();
    if (settings.type.match(/PUT|POST/)) {
      if (settings.data) {
        settings.data = JSON.stringify(settings.data);
      }
    }
    return settings;
  },

  makeSuccess: function(response) {
    return response;
  },

  makeError: function(jqXHR) {
    var result = jqXHR.responseJSON;
    if (!result) {
      return new CWError(jqXHR.status + jqXHR.statusText, jqXHR.status);
    }
    return new CWError(result.message || result.error, jqXHR.status);
  },

  // Build url by modelTypeKey and id
  buildUrl: function(modelTypeKey, id) {
    var path = !id ? pluralize(modelTypeKey) : pluralize(modelTypeKey) + '/' + id;
    return api.host + api.namespace + '/' + path;
  }
});
