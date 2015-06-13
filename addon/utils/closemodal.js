import Ember from 'ember';

function CloseModal(attributes) {
  this.container = attributes.container;
  this.closeModal = function(title, message, type) {
    var ctrl = this.container.lookup('controller:application');
    ctrl.send('closeModal', title, message, type);
  };
}

CloseModal.create = function(attributes) {
  var closeModal = new CloseModal(attributes);
  var fn = Ember.run.bind(closeModal, closeModal.closeModal);
  fn.destroy = function() {};
  return fn;
};

export default CloseModal;
