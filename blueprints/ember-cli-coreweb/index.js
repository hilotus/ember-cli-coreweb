module.exports = {
  description: 'Blueprint for ember-cli-coreweb',

  normalizeEntityName: function() {},

  afterInstall: function() {
    var self = this;

    return self.addBowerPackageToProject('pure', '~0.6.0').then(function(){
      return self.addBowerPackageToProject('font-awesome', '~4.3.0');
    }).then(function(){
      return self.addBowerPackageToProject('markdown-it', '~4.2.1');
    }).then(function(){
      return self.addBowerPackageToProject('markdown-it-footnote', '~1.0.0');
    }).then(function(){
      return self.addBowerPackageToProject('codemirror', '~5.3.0');
    }).then(function(){
      return self.addBowerPackageToProject('emojify.js', '~1.0.2');
    });
  }
};
