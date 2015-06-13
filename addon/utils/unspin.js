import Ember from 'ember';

function Unspin(attributes) {
  this.container = attributes.container;
  this.unspin = function() {
    var ctrl = this.container.lookup('controller:application');
    ctrl.send('closeSpinner');
  };
}

Unspin.create = function(attributes) {
  var unspin = new Unspin(attributes);
  var fn = Ember.run.bind(unspin, unspin.unspin);
  fn.destroy = function() {};
  return fn;
};

export default Unspin;
