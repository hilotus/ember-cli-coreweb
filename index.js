/* jshint node: true */
'use strict';

module.exports = {
  name: 'ember-cli-coreweb',

  included: function(app) {
    this._super.included(app);

    // pure css
    app.import(app.bowerDirectory + '/pure/grids-min.css');
    app.import(app.bowerDirectory + '/pure/grids-responsive-min.css');

    // font awesome
    app.import(app.bowerDirectory + '/font-awesome/fonts/fontawesome-webfont.ttf', {destDir: "fonts"});
    app.import(app.bowerDirectory + '/font-awesome/fonts/fontawesome-webfont.eot', {destDir: "fonts"});
    app.import(app.bowerDirectory + '/font-awesome/fonts/fontawesome-webfont.svg', {destDir: "fonts"});
    app.import(app.bowerDirectory + '/font-awesome/fonts/fontawesome-webfont.woff', {destDir: "fonts"});
    app.import(app.bowerDirectory + '/font-awesome/fonts/fontawesome-webfont.woff2', {destDir: "fonts"});
    app.import(app.bowerDirectory + '/font-awesome/fonts/FontAwesome.otf', {destDir: "fonts"});
    app.import(app.bowerDirectory + '/font-awesome/css/font-awesome.min.css');

    // markdown editor
    app.import(app.bowerDirectory + '/markdown-it/dist/markdown-it.min.js');
    app.import(app.bowerDirectory + '/markdown-it-footnote/dist/markdown-it-footnote.min.js');
    app.import(app.bowerDirectory + '/highlightjs/highlight.pack.js');
    app.import(app.bowerDirectory + '/highlightjs/styles/default.css');
    app.import(app.bowerDirectory + '/emojify.js/dist/js/emojify.min.js');
    app.import(app.bowerDirectory + '/codemirror/lib/codemirror.js');
    app.import(app.bowerDirectory + '/codemirror/lib/codemirror.css');
    app.import(app.bowerDirectory + '/codemirror/addon/mode/overlay.js');
    app.import(app.bowerDirectory + '/codemirror/mode/xml/xml.js');
    app.import(app.bowerDirectory + '/codemirror/mode/markdown/markdown.js');
    app.import(app.bowerDirectory + '/codemirror/mode/gfm/gfm.js');
    app.import(app.bowerDirectory + '/codemirror/mode/javascript/javascript.js');
    app.import(app.bowerDirectory + '/codemirror/mode/css/css.js');
    app.import(app.bowerDirectory + '/codemirror/mode/htmlmixed/htmlmixed.js');
    app.import(app.bowerDirectory + '/codemirror/addon/edit/continuelist.js');
    app.import(app.bowerDirectory + '/codemirror/theme/base16-light.css');
  }
};
