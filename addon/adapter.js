import Ember from 'ember';

export default Ember.Object.extend({
  // make sure ajax service is initialized.
  ajaxService: null,

  find: function(modelTypeKey, id) {
    if (typeof id === "string") {
      return this.findById(modelTypeKey, id);
    }
    var settings = {
      url: this.ajaxService.buildUrl(modelTypeKey),
      type: 'get',
      data: id
    };
    return this.ajaxService.sendRequest(settings);
  },

  findById: function(modelTypeKey, id) {
    var settings = {
      url: this.ajaxService.buildUrl(modelTypeKey, id),
      type: 'get'
    };
    return this.ajaxService.sendRequest(settings);
  },

  createRecord: function(modelTypeKey, data) {
    var settings = {
      url: this.ajaxService.buildUrl(modelTypeKey),
      type: 'post',
      data: data,
      contentType: 'application/json; charset=utf-8'
    };
    return this.ajaxService.sendRequest(settings);
  },

  updateRecord: function(modelTypeKey, id, data) {
    var settings = {
      url: this.ajaxService.buildUrl(modelTypeKey, id),
      type: 'put',
      data: data,
      contentType: 'application/json; charset=utf-8'
    };
    return this.ajaxService.sendRequest(settings);
  },

  destroyRecord: function(modelTypeKey, id) {
    var settings = {
      url: this.ajaxService.buildUrl(modelTypeKey, id),
      type: 'delete'
    };
    return this.ajaxService.sendRequest(settings);
  }
});
