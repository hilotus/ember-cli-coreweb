module.exports = {
  description: 'Blueprint for ember-cli-coreweb',

  normalizeEntityName: function() {},

  afterInstall: function() {
    return this.addBowerPackagesToProject([
      'pure',
      'font-awesome',
      'markdown-it',
      'markdown-it-footnote',
      'highlightjs',
      'codemirror',
      'emojify.js'
      // { name: 'pure', target: '0.6.0' },
      // { name: 'font-awesome', target: '4.3.0' },
      // { name: 'markdown-it', target: '4.2.1' },
      // { name: 'markdown-it-footnote', target: '1.0.0' },
      // { name: 'highlightjs', target: '8.5.0' },
      // { name: 'codemirror', target: '5.3.0' },
      // { name: 'emojify.js', target: '1.0.2' },
      // { name: 'font-awesome', target: '4.3.0' }
    ]);
  }
};
