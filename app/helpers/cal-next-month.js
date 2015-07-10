import Ember from "ember";

export default Ember.Handlebars.makeBoundHelper(function(day, today) {
  var checkd;
  if (day[0] > today[0]) {
    checkd = true;
  } else {
    checkd = day[1] > today[1];
  }

  var escaped = checkd ? 'cal-next-month' : '';
  return new Ember.Handlebars.SafeString(escaped);
});
