import Ember from "ember";

export default Ember.Handlebars.makeBoundHelper(function(index, month) {
  var escaped = index + 1 === month ? 'sel' : '';
  return new Ember.Handlebars.SafeString(escaped);
});
