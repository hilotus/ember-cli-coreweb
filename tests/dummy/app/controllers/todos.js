import Ember from 'ember';
import Todo from '../models/todo';

export default Ember.Controller.extend({
  addValue: '',
  model: [],

  buttonDisabled: Ember.computed('addValue', function() {
    return !this.addValue;
  }),

  actions: {
    add: function() {
      var self, todo;
      self = this;
      todo = new Todo();
      todo.setVals({
        title: this.addValue,
        isCompleted: false
      });
      return todo.save().then(function() {
        self.model.pushObject(todo);
        return self.set('addValue', '');
      });
    },

    del: function(todo) {
      var self;
      self = this;
      return todo["delete"]().then(function() {
        return self.model.removeObject(todo);
      });
    },

    saveChanges: function() {
      return this.store.commitChanges();
    }
  }
});
