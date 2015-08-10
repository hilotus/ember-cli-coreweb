import Ember from 'ember';

export default Ember.Object.extend({
  // make sure ajax service is initialized.
  ajaxService: null,

  find: function(modelTypeKey, id) {
    if (typeof id === "string") {
      return this.findById(modelTypeKey, id);
    }

    return this.ajaxService.ajax(this.ajaxService.buildUrl(modelTypeKey), "GET", { data: id});
  },

  findById: function(modelTypeKey, id) {
    return this.ajaxService.ajax(this.ajaxService.buildUrl(modelTypeKey, id), "GET");
  },

  createRecord: function(modelTypeKey, data) {
    return this.ajaxService.ajax(this.ajaxService.buildUrl(modelTypeKey), "POST", { data: data });
  },

  updateRecord: function(modelTypeKey, id, data) {
    return this.ajaxService.ajax(this.ajaxService.buildUrl(modelTypeKey, id), "PUT", { data: data });
  },

  destroyRecord: function(modelTypeKey, id) {
    return this.ajaxService.ajax(this.ajaxService.buildUrl(modelTypeKey, id), "DELETE");
  }
});
