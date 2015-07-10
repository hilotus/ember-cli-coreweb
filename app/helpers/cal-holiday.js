import Ember from "ember";

export default Ember.Handlebars.makeBoundHelper(function(day) {
  var escaped = day >= 5 ? 'cal-holiday' : '';
  return new Ember.Handlebars.SafeString(escaped);
});
