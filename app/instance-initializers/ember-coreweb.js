import Ember from 'ember';
import ENV from '../config/environment';

import 'ember-cli-coreweb/array_ext';

export default {
  name: 'ember-cli-coreweb',
  after: 'coreweb',

  initialize: function(instance) {
    var CW = ENV.CW || ENV.default.CW || {};

    var api = instance.container.lookup('service:api');
    api.set('options', CW.api);
    instance.container.lookup('store:-cw').set('api', api);
  }
}
