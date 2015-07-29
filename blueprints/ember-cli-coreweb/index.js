module.exports = {
  description: 'The blueprint for ember-cli-coreweb',

  normalizeEntityName: function() {},

  afterInstall: function(options) {
    return this.addBowerPackageToProject('async', '~1.4.0');
  }
};
