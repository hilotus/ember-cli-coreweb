import Ember from 'ember';

function Alert(attributes) {
  this.container = attributes.container;
  this.alert = function(title, message, type) {
    var appCtrl = this.container.lookup('controller:application');
    appCtrl.send('showAlert', title, message, type);
  };
}

Alert.create = function(attributes) {
  var alert = new Alert(attributes);
  var fn = Ember.run.bind(alert, alert.alert);
  fn.destroy = function() {};
  return fn;
};

export default Alert;
