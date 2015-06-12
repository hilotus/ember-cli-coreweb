import Ember from 'ember';

function Confirm(attributes) {
  this.container = attributes.container;
  this.confirm = function(title, message, type, okButton) {
    var ctrl = this.container.lookup('controller:application');
    ctrl.send('showConfirm', title, message, type, okButton);
  };
}

Confirm.create = function(attributes) {
  var confirm = new Confirm(attributes);
  var fn = Ember.run.bind(confirm, confirm.confirm);
  fn.destroy = function() {};
  return fn;
};

export default Confirm;
