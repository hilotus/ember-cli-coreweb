var Post = CW.Model.extend();

Post.reopenClass({
  typeKey: 'post',
  schema: {
    id: {type: 'string'},
    title: {type: 'string'},
    body: {type: 'string'},
    creator: {type: 'belongTo', className: 'user'},
    category: {type: 'belongTo', className: 'term'},
    tags: {type: 'hasMany', className: 'term'},
    createdAt: {type: 'timestamps'},
    updatedAt: {type: 'timestamps'}
  }
});

export default Post;
