/* jshint node: true */
'use strict';

module.exports = {
  name: 'ember-cli-coreweb',

  included: function (app) {
    this._super.included(app);

    app.import(app.bowerDirectory + '/async/dist/async.min.js');
  }
};
