var Term = CW.Model.extend({
});

Term.reopenClass({
  typeKey: 'term',
  schema: {
    id: {type: 'string'},
    color: {type: 'string'},
    creator: {type: 'belongTo', className: 'user'},
    name: {type: 'string'},
    createdAt: {type: 'timestamps'},
    updatedAt: {type: 'timestamps'}
  }
});

export default Term;
