module.exports = {
  description: ''

  normalizeEntityName: function() {},

  afterInstall: function(options) {
    return this.addBowerPackageToProject('async', '~1.4.0');
  }
};
