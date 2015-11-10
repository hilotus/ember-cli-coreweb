var Field = CW.Model.extend();

Field.reopenClass({
  typeKey: 'field',
  schema: {
    id: {type: 'string'},
    title: {type: 'string'},
    createdAt: {type: 'timestamps'},
    updatedAt: {type: 'timestamps'}
  }
});

export default Field;
