import Ember from 'ember';

var User = CW.Model.extend();

/*
 * User Action
 */
User.reopenClass({
  typeKey: 'user',
  schema: {
    id: {type: 'string'},
    username: {type: 'string'},
    emailVerified: {type: 'boolean'},
    email: {type: 'string'},
    locale: {type: 'string'},
    createdAt: {type: 'timestamps'},
    updatedAt: {type: 'timestamps'}
  }
});

export default User;
