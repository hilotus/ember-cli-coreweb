import Ember from 'ember';
import ENV from '../config/environment';

export default {
  name: 'ember-cli-coreweb',
  after: 'coreweb',

  initialize: function(instance) {
    var CW = ENV.CW || ENV.default.CW || {};

    var defaultApi = CW.defaultApi,
      parseApi = CW.parseApi,
      adapter = instance.container.lookup('adapter:-cw'),
      service, api;

    if (parseApi) {
      api = Ember.copy(parseApi);
      service = instance.container.lookup('service:parse-ajax');
    } else {
      if (defaultApi) {
        api = Ember.copy(defaultApi);
      } else {
        Ember.warn('ember-cli-coreweb did not find a default api config; falling back to "http://localhost:9292/1".');
        api = {host: 'http://localhost:9292', namespace: '1'};
      }
      service = instance.container.lookup('service:ajax');
    }

    service.set('api', api);
    adapter.set('ajaxService', service);
    instance.container.lookup('store:-cw').set('adapter', adapter);
  }
}
