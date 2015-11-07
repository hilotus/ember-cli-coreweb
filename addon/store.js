import Ember from 'ember';
import { CustomError } from './error';

var __cache__ = {};

export default Ember.Object.extend({
  api: null,

  find: function (modelTypeKey, id) {
    if (!id) { id = {}; }

    if (typeof id === 'string') {
      return this.findById(modelTypeKey, id);
    }

    return this.api.query(modelTypeKey, id)
      .then(function (json) {
        return Ember.RSVP.resolve(json.results.map(function (result) {
          return this.push(modelTypeKey, result);
        }, this));
      }.bind(this));
  },

  findById: function (modelTypeKey, id) {
    var record;
    if (__cache__[modelTypeKey] && (record = __cache__[modelTypeKey][id])) {
      return Ember.RSVP.resolve(record);
    }

    return this.api.query(modelTypeKey, id)
      .then(function (json) {
        return Ember.RSVP.resolve(this.push(modelTypeKey, json));
      }.bind(this));
  },

  createRecord: function (modelTypeKey, data, record) {
    return this.api.post(modelTypeKey, data)
      .then(function (json) {
        data.id = json._id || json.objectId;
        Ember.merge(data, json);
        record = this.push(modelTypeKey, data, record);
        return Ember.RSVP.resolve(record);
      }.bind(this));
  },

  updateRecord: function (modelTypeKey, id, data) {
    return this.api.put(modelTypeKey, id, data)
      .then(function (json) {
        Ember.merge(data, json);
        var record = this.reload(modelTypeKey, data, id);
        return Ember.RSVP.resolve(record);
      }.bind(this));
  },

  destroyRecord: function (modelTypeKey, id) {
    return this.api.delete(modelTypeKey, id)
      .then(function () {
        var record = this.pull(modelTypeKey, id);
        return Ember.RSVP.resolve(record);
      }.bind(this));
  },

  commitChanges: function () {
    var collection, model, modelId, modelTypeKey, promises, models = [];

    for (modelTypeKey in __cache__) {
      collection = __cache__[modelTypeKey];
      for (modelId in collection) {
        model = collection[modelId];
        models.push(model);
      }
    }
    promises = models.map(function (item) { return item.save(); });
    return Ember.RSVP.Promise.all(promises);
  },

  push: function (modelTypeKey, json, record) {
    if (Ember.isArray(json)) {
      return json.map(function (j) {
        return this.__push(modelTypeKey, j, record);
      }, this);
    } else {
      return this.__push(modelTypeKey, json, record);
    }
  },

  reload: function (modelTypeKey, data, id) {
    var record = __cache__[modelTypeKey][id];
    if (!record) {
      throw new CustomError('The record (id: ' + id + ', modelTypeKey: ' + modelTypeKey + ') is not exist.', 541);
    }
    record.merge(data);
    record.normalize();
    return record;
  },

  pull: function (modelTypeKey, id) {
    var record = __cache__[modelTypeKey][id];
    if (!record) {
      throw new CustomError('The record (id: ' + id + ', modelTypeKey: ' + modelTypeKey + ') is not exist.', 541);
    }
    delete __cache__[modelTypeKey][id];
    record.pull();
    return record;
  },

  /************************/

  __getModelClazz: function (modelTypeKey) {
    return this.container.lookupFactory("model:" + modelTypeKey);
  },

  __push: function (modelTypeKey, json, record) {
    json.id = json.id || json._id || json.objectId;
    delete json._id;
    delete json.objectId;

    if (!__cache__[modelTypeKey]) {
      __cache__[modelTypeKey] = {};
    }

    if (Ember.isNone(record)) {
      record = this.__getModelClazz(modelTypeKey).create();
    }

    if (!__cache__[modelTypeKey][json.id]) {
      __cache__[modelTypeKey][json.id] = record;
    }

    record.merge(json);
    record.normalize();
    return record;
  }
});
