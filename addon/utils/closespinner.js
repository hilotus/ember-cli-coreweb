import Ember from 'ember';

function CloseSpin(attributes) {
  this.container = attributes.container;
  this.closeSpinner = function() {
    var ctrl = this.container.lookup('controller:application');
    ctrl.send('closeSpinner');
  };
}

CloseSpin.create = function(attributes) {
  var closeSpinner = new CloseSpin(attributes);
  var fn = Ember.run.bind(closeSpinner, closeSpinner.closeSpinner);
  fn.destroy = function() {};
  return fn;
};

export default CloseSpin;
