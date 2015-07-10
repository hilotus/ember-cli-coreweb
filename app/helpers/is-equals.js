import Ember from "ember";

var arraysEqual = function(a, b) {
  if (a === b) return true;
  if (a == null || b == null) return false;
  if (a.length != b.length) return false;

  // If you don't care about the order of the elements inside
  // the array, you should sort both arrays here.

  for (var i = 0; i < a.length; ++i) {
    if (a[i] !== b[i]) return false;
  }
  return true;
}

export default Ember.Handlebars.makeBoundHelper(function(value1, value2, options) {
  var checked;
  if (Ember.isArray(value1) && Ember.isArray(value2)) {
    checked = arraysEqual(value1, value2);
  } else {
    checked = value1 === value2;
  }

  var escaped = checked ? options : '';
  return new Ember.Handlebars.SafeString(escaped);
});
