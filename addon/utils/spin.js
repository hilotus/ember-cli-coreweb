import Ember from 'ember';

function Spin(attributes) {
  this.container = attributes.container;
  this.spin = function(label) {
    var ctrl = this.container.lookup('controller:application');
    ctrl.send('showSpinner', label);
  };
}

Spin.create = function(attributes) {
  var spin = new Spin(attributes);
  var fn = Ember.run.bind(spin, spin.spin);
  fn.destroy = function() {};
  return fn;
};

export default Spin;
