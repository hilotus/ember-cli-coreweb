import Ember from 'ember';

import Adapter from './adapter';
import Store from './store';
import Model from './model';

var CW = Ember.Namespace.create({
  VERSION: '1.0.0',
  Adapter: Adapter,
  Store: Store,
  Model: Model
});

if (Ember.libraries) {
  Ember.libraries.registerCoreLibrary('CoreWeb', CW.VERSION);
}

Ember.defineProperty(CW, 'normalizeModelName', {
  enumerable: true,
  writable: false,
  configurable: false,
  value: function(modelName) {
    Ember.String.dasherize(modelName);
  }
});

Ember.lookup.CW = CW;

export default CW;
