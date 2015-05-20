import Ember from 'ember';

var Todo = CW.Model.extend();

Todo.reopenClass({
  typeKey: 'todo'
});

export default Todo;
