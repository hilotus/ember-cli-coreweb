import Ember from "ember";

export default Ember.Handlebars.makeBoundHelper(function(value1, value2, options) {
  var escaped = value1 > value2 ? options : '';
  return new Ember.Handlebars.SafeString(escaped);
});
