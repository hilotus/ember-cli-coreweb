var Post = CW.Model.extend({
  // 是否为登录用户创建
  isMe: function() {
    var user = this.container.lookup("user:current");
    return user && user.get("id") === this.get('creator.id');
  }.property('creator'),

  articleUrl: function() {
    return "http://www.hilotus.com/posts/" + this.get('id');
  }.property('id')
});

Post.reopenClass({
  typeKey: 'Post',
  schema: {
    'belongTo': {'creator': 'User', 'category': 'Term'},
    'hasMany': {'tags': 'Term'}
  }
});

export default Post;
