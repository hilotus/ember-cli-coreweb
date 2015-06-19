import Ember from 'ember';
import config from './config/environment';

var Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('checkbox');
  this.route('button');
  this.route('dropbutton');
  this.route('picker');
  this.route('todos');
  this.route('markdowneditor');
  this.route('inputs');
});

export default Router;
