module.exports = {
  description: 'The blueprint for ember-cli-coreweb',

  normalizeEntityName: function() {},

  afterInstall: function(options) {
    return this.addBowerPackageToProject('async', '~1.4.0').then(function() {
      return this.addBowerPackageToProject('pluralize', '~1.1.4');
    }.bind(this));
  }
};
