module.exports = {
  description: 'Blueprint for ember-cli-coreweb',

  normalizeEntityName: function() {},

  afterInstall: function() {
    return this.addBowerPackagesToProject([
      { name: 'pure', target: '0.6.0' },
      { name: 'font-awesome', target: '4.3.0' }
    ]);
  }
};
