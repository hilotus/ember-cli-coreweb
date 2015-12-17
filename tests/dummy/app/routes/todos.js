import Ember from 'ember';

export default Ember.Route.extend({
  model: function() {
    var ctrl, where;
    ctrl = this.controllerFor('todos');
    if (Ember.isBlank(ctrl.get('model'))) {
      where = {isCompleted: false};
      return this.store.find('todo', { where: JSON.stringify(where) } );
    }
  }
});
