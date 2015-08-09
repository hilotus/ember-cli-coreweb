import Ember from 'ember';
import parseAjax from 'ember-cli-coreweb/parse-ajax';

var Parent = Ember.Service || Ember.Object;

export default Parent.extend(parseAjax);
