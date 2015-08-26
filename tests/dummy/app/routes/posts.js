import Ember from 'ember';

export default Ember.Route.extend({
  model: function() {
    var ctrl;
    ctrl = this.controllerFor('application');
    if (Ember.isBlank(ctrl.get('model'))) {
      return this.store.find('post');
    }
  }
});
