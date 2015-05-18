module.exports = {
  description: 'Blueprint for ember-cli-coreweb',

  normalizeEntityName: function() {},

  afterInstall: function() {
    return this.addBowerPackagesToProject([
      { name: 'pure' },
      { name: 'font-awesome'}
    ]);
  }
};
