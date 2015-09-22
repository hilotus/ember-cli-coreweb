import Ember from 'ember';

import Store from './store';
import Model from './model';
import CWError from './error';

var CW = Ember.Namespace.create({
  VERSION: '1.0.0',
  Store: Store,
  Model: Model,
  Error: CWError
});

if (Ember.libraries) {
  Ember.libraries.registerCoreLibrary('CoreWeb', CW.VERSION);
}

Ember.defineProperty(CW, 'normalizeModelName', {
  enumerable: true,
  writable: false,
  configurable: false,
  value: function (modelName) {
    Ember.String.dasherize(modelName);
  }
});

Ember.lookup.CW = CW;

export default CW;
