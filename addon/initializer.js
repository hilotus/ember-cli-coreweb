import Ember from 'ember';
import CW from './core';

Ember.onLoad('Ember.Application', function (Application) {
  Application.initializer({
    name: 'coreweb',

    initialize: function (registry) {
      registry.register('store:-cw', CW.Store);
      registry.injection('controller', 'store', 'store:-cw');
      registry.injection('route', 'store', 'store:-cw');
    }
  });

  Application.instanceInitializer({
    name: 'coreweb',

    initialize: function (instance) {
      CW.Model.reopen({store: instance.container.lookup("store:-cw")});
    }
  });
});
