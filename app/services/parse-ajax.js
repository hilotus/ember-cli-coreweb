import AjaxService from './ajax';

export default AjaxService.extend({
  host: 'https://api.parse.com',
  namespace: '1',
  classesPath: 'classes',

  // Set after login
  sessionToken: '',

  parseArgs: function() {
    var settings = this._super.apply(this, arguments);
    var self = this;

    settings.beforeSend = function(xhr) {
      xhr.setRequestHeader('X-Parse-Application-Id', self.get('api.applicationId'));
      xhr.setRequestHeader('X-Parse-REST-API-Key', self.get('api.restApiKey'));

      /*
      * 1. Validating Session Tokens / Retrieving Current User / logout
      * 2. Updating Users
      * 3. Deleting Users
      */
      if (settings.url.match(/users\/me/)
          || (settings.url.match(/users/) && settings.type.match(/PUT|DELETE/))
          || (settings.url.match(/logout/) && settings.type.match(/POST/))) {
        xhr.setRequestHeader('X-Parse-Session-Token', self.get('sessionToken'));
      }
    };
    return settings;
  },

  // Build url by modelTypeKey and id
  buildUrl: function(modelTypeKey, id) {
    var path;

    if (modelTypeKey.match(/user|users|requestPasswordReset|login|logout/)) {
      path = modelTypeKey === 'user' ? 'users' : modelTypeKey;
      if (!!id) {
        path = path + '/' + id;
      }
      return this.host + '/' + this.namespace + '/' + path
    } else {
      path = modelTypeKey.classify();

      if (!!id) {
        path = path + '/' + id;
      }
      return this.host + '/' + this.namespace + '/' + this.classesPath + '/' + path
    }
  }
});
