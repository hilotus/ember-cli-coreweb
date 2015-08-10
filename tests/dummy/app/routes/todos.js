import Ember from 'ember';

export default Ember.Route.extend({
  model: function() {
    var ctrl;
    ctrl = this.controllerFor('todos');
    if (Ember.isBlank(ctrl.get('model'))) {
      return this.store.find('todo');
    }
  }
});
