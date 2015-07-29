var Term = CW.Model.extend({
});

Term.reopenClass({
  typeKey: 'Term',
  schema: {
    'belongTo': {'creator': 'User'},
    'hasMany': {}
  }
});

export default Term;
