import Ember from 'ember';

var User = CW.Model.extend();

/*
 * User Action
 */
User.reopenClass({
  typeKey: 'User'
});

export default User;
