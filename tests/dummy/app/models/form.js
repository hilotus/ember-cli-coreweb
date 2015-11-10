var Form = CW.Model.extend();

Form.reopenClass({
  typeKey: 'form',
  schema: {
    id: {type: 'string'},
    title: {type: 'string'},
    field: {type: 'embedsIn', className: 'field'},
    fields: {type: 'hasMany', className: 'field'},
    createdAt: {type: 'timestamps'},
    updatedAt: {type: 'timestamps'}
  }
});

export default Form;
