import Ember from 'ember';
import ENV from '../config/environment';

export default {
  name: 'ember-cli-coreweb',
  after: 'coreweb',

  initialize: function(instance) {
    var CW = ENV.CW || ENV.default.CW || {};

    var defaultApi = CW.defaultApi,
      parseApi = CW.parseApi,
      store = instance.container.lookup('store:-cw'),
      adapter, api;

    if (parseApi) {
      adapter = instance.container.lookup('adapter:-parse');
      api = parseApi;
    } else {
      adapter = instance.container.lookup('adapter:-cw');
      if (defaultApi) {
        api = defaultApi;
      } else {
        Ember.warn('ember-cli-coreweb did not find a default api config; falling back to "http://localhost:9292/1".');
        api = {host: 'http://localhost:9292', namespace: '/'};
      }
    }

    adapter.set('api', api);
    store.set('defaultModels', CW.defaultModels);

    if (parseApi) {
      instance.container.lookup('service:parse-ajax').setProperties({'api': api, 'store': store});
    } else {
      instance.container.lookup('service:ajax').setProperties({'api': api, 'store': store});
    }

    instance.container.lookup('store:-cw').set('adapter', adapter);
  }
}
