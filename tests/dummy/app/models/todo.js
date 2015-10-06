var Todo = CW.Model.extend({
});

Todo.reopenClass({
  typeKey: 'todo',
  schema: {
    id: {type: 'string'},
    isCompleted: {type: 'boolean'},
    title: {type: 'string'},
    createdAt: {type: 'timestamps'},
    updatedAt: {type: 'timestamps'}
  }
});

export default Todo;
