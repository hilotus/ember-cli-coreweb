import Ember from 'ember';
import Todo from '../models/todo';

export default Ember.Controller.extend({
  addValue: '',
  model: [],

  buttonDisabled: Ember.computed('addValue', function() {
    return !this.addValue;
  }),

  actions: {
    add: function () {
      var todo = new Todo();
      todo.setProperties({
        title: this.addValue,
        isCompleted: false
      });
      return todo.save().then(function (record) {
        this.model.pushObject(record);
        return this.set('addValue', '');
      }.bind(this));
    },

    del: function (todo) {
      return todo.delete().then(function (record) {
        return this.model.removeObject(record);
      }.bind(this));
    },

    saveChanges: function () {
      return this.store.commitChanges();
    },

    saveChanges2: function () {
      return this.store.commitChanges('todo').catch(function (err) {
        console.log(err.message);
      });
    }
  }
});
