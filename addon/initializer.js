import Ember from 'ember';
import CW from './core';

Ember.onLoad('Ember.Application', function (Application) {
  Application.initializer({
    name: 'coreweb',

    initialize: function (registry, a, b) {
      registry.register('store:-cw', CW.Store);
      registry.inject('controller', 'store', 'store:-cw');
      registry.inject('route', 'store', 'store:-cw');
    }
  });

  Application.instanceInitializer({
    name: 'coreweb',

    initialize: function (instance) {
      CW.Model.reopen({store: instance.lookup("store:-cw")});
    }
  });
});
