import Ember from 'ember';
import { CustomError } from './error';
import pluralize from 'ember-cli-coreweb/pluralize';

var __cache__ = {};

export default Ember.Object.extend({
  api: null,

  find: function (modelTypeKey, id) {
    if (!id) { id = {}; }

    if (typeof id === 'string') {
      return this.findById(modelTypeKey, id);
    }

    return this.api.query(this.__buildPath(modelTypeKey), id)
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

    return this.api.query(this.__buildPath(modelTypeKey, id))
      .then(function (json) {
        return Ember.RSVP.resolve(this.push(modelTypeKey, json));
      }.bind(this));
  },

  createRecord: function (modelTypeKey, data, record) {
    // merge default value to data.
    var Model = this.__getModelClazz(modelTypeKey),
      schema = Model.schema,
      key;

    for (key in schema) {
      if (!data[key] && typeof schema[key].defaultValue !== 'undefined') {
        data[key] = schema[key].defaultValue;
      }
    }

    return this.api.post(this.__buildPath(modelTypeKey), data)
      .then(function (json) {
        data.id = json._id || json.objectId;
        Ember.merge(data, json);
        record = this.push(modelTypeKey, data, record);
        return Ember.RSVP.resolve(record);
      }.bind(this));
  },

  updateRecord: function (modelTypeKey, id, data) {
    return this.api.put(this.__buildPath(modelTypeKey, id), data)
      .then(function (json) {
        Ember.merge(data, json);
        var record = this.reload(modelTypeKey, data, id);
        return Ember.RSVP.resolve(record);
      }.bind(this));
  },

  destroyRecord: function (modelTypeKey, id) {
    return this.api.delete(this.__buildPath(modelTypeKey, id))
      .then(function () {
        var record = this.pull(modelTypeKey, id);
        return Ember.RSVP.resolve(record);
      }.bind(this));
  },

  commitChanges: function (modelTypeKey) {
    var collection, model, modelId, promises, models = [];

    if (modelTypeKey) {
      collection = __cache__[modelTypeKey];
      for (modelId in collection) {
        model = collection[modelId];
        models.push(model);
      }
    } else {
      for (modelTypeKey in __cache__) {
        collection = __cache__[modelTypeKey];
        for (modelId in collection) {
          model = collection[modelId];
          models.push(model);
        }
      }
    }

    promises = models.map(function (item) {
      return item.save().then(record => {
        return Ember.RSVP.resolve(record);
      }).catch(err => {
        if (err.code === 532 || err.code === 531) {
          return Ember.RSVP.resolve();
        } else {
          return Ember.RSVP.reject(err);
        }
      });
    });
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

    // We will replace the old existed record
    if (!__cache__[modelTypeKey][json.id]) {
      __cache__[modelTypeKey][json.id] = record;
    }

    record.merge(json);
    record.normalize();
    return record;
  },

  __buildPath: function (modelTypeKey, id) {
    var path, notObjectApi;

    if (this.get('api.options.parse')) {
      notObjectApi = modelTypeKey.match(/user|users|requestPasswordReset|login|logout|functions|jobs/);

      if (notObjectApi) {  // User api
        path = modelTypeKey === 'user' ? 'users' : modelTypeKey;
      } else {  // other Object api
        path = modelTypeKey.classify();
      }

      if (typeof id === 'string') {
        path = path + '/' + id;
      }

      if (!notObjectApi) {
        path = this.get('api.options.classesPath') + '/' + path;
      }
    } else {
      path = pluralize(modelTypeKey);
      if (typeof id === 'string') {
        path = path + '/' + id;
      }
    }
    return path;
  }
});
