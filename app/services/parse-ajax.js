import AjaxService from './ajax';

export default AjaxService.extend({
  host: 'https://api.parse.com',
  namespace: '1',
  classesPath: 'classes',

  // Set after login
  sessionToken: '',

  ajaxOptions: function(url, type, options) {
    var options = this._super.apply(this, arguments);
    delete options.xhrFields;

    var self = this;
    options.beforeSend = function(xhr) {
      xhr.setRequestHeader('X-Parse-Application-Id', self.get('api.applicationId'));
      xhr.setRequestHeader('X-Parse-REST-API-Key', self.get('api.restApiKey'));

      /*
      * 1. Validating Session Tokens / Retrieving Current User
      * 2. Updating Users
      * 3. Deleting Users
       */
      if ((options.url.match(/users\/me/) && options.type === 'GET')
          || (options.type.match(/PUT|DELETE/) && options.url.match(/users/))
          || (options.type === 'POST' && options.url.match(/logout/))) {
        return xhr.setRequestHeader('X-Parse-Session-Token', self.get('sessionToken'));
      }
    };
    return options;
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
