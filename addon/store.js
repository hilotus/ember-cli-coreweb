import Ember from 'ember';

var __cache__ = {};

export default Ember.Object.extend({
  api: null,

  find: function(modelTypeKey, id) {
    var self;
    if (id == null) {
      id = {};
    }
    if (typeof id === 'string') {
      return this.findById(modelTypeKey, id);
    }
    self = this;
    return this.api.query(modelTypeKey, id).then(function(json) {
      return Ember.RSVP.resolve(json.results.map(function(result) {
        return self.push(modelTypeKey, result);
      }));
    });
  },

  findById: function(modelTypeKey, id) {
    var record, self;
    self = this;
    if (__cache__[modelTypeKey] && (record = __cache__[modelTypeKey][id])) {
      return Ember.RSVP.resolve(record);
    }
    return this.api.query(modelTypeKey, id).then(function(json) {
      return Ember.RSVP.resolve(self.push(modelTypeKey, json));
    });
  },

  createRecord: function(modelTypeKey, data, record) {
    var self;
    self = this;
    return this.api.post(modelTypeKey, data).then(function(json) {
      data.id = json._id || json.objectId;
      Ember.merge(data, json);
      self.push(modelTypeKey, data, record);
      return Ember.RSVP.resolve();
    });
  },

  updateRecord: function(modelTypeKey, id, data) {
    var self;
    self = this;
    return this.api.put(modelTypeKey, id, data).then(function(json) {
      self.reload(modelTypeKey, json, id);
      return Ember.RSVP.resolve();
    });
  },

  destroyRecord: function(modelTypeKey, id) {
    var self;
    self = this;
    return this.api.delete(modelTypeKey, id).then(function() {
      self.pull(modelTypeKey, id);
      return Ember.RSVP.resolve();
    });
  },

  commitChanges: function() {
    var collection, model, modelId, modelTypeKey, models = [];

    for (modelTypeKey in __cache__) {
      collection = __cache__[modelTypeKey];
      for (modelId in collection) {
        model = collection[modelId];
        models.push(model);
      }
    }

    var promises = models.map(function (item) {
      return item.commitChanges();
    });

    return Ember.RSVP.Promise.all(promises);
  },

  push: function(clazz, json, record) {
    var records, self;
    self = this;
    if (Ember.isArray(json)) {
      records = [];
      return json.map(function(j) {
        return self.__push(clazz, j, record);
      });
    } else {
      return self.__push(clazz, json, record);
    }
  },

  reload: function(modelTypeKey, json, id) {
    var record;
    record = __cache__[modelTypeKey][id];
    if (!record) {
      throw new Ember.Error("There is no " + modelTypeKey + " exists find by id " + id + ".");
    }
    Ember.merge(json, record.get('changeData'));
    record.merge(json);
    __cache__[modelTypeKey][record.get('id')] = record;
    return this.normalize(record, record.get('modelData'));
  },

  pull: function(typeKey, id) {
    return this.__pull(typeKey, id);
  },

  /*
    schema: {
      'belongTo': {'creator': 'user', 'category': 'term'},
      'hasMany': {'tags': 'term'}
    }
  */
  normalize: function(record, data) {
    var key, schema, value;
    schema = record.constructor.schema;
    for (key in data) {
      value = data[key];
      if (!Ember.isNone(schema.belongTo[key])) {
        this.__normalizeBelongTo(record, schema.belongTo[key], key, value);
      } else if (!Ember.isNone(schema.hasMany[key])) {
        this.__normalizeHasMany(record, schema.hasMany[key], key, value);
      } else {
        record.set(key, this.__normalizeNormal(value));
      }
    }
    return record;
  },

  /************************/

  __normalizeBelongTo: function(record, typeKey, key, value) {
    return this.find(typeKey, value).then(function(r) {
      return record.set(key, r);
    });
  },

  /**
    values: id array.
  **/
  __normalizeHasMany: function(record, typeKey, key, values) {
    var promises = values.map(function (id) {
      return this.find(typeKey, id);
    }.bind(this));

    record.set(key, []);

    Ember.RSVP.all(promises)
      .then(function (records) {
        record.get(key).pushObjects(records);
      });
  },

  __normalizeNormal: function(data) {
    var key, v, value;
    if (Ember.$.isPlainObject(data)) {
      v = Ember.Object.create();
      for (key in data) {
        value = data[key];
        v.set(key, this.__normalizeNormal(value));
      }
      return v;
    } else {
      return data;
    }
  },

  __getModelClazz: function(clazz) {
    if (typeof clazz !== 'string') {
      return clazz;
    }
    return this.container.lookup("model:" + (clazz.toLowerCase())).constructor;
  },

  __push: function(clazz, json, record) {
    clazz = this.__getModelClazz(clazz);
    json.id = json.id || json._id || json.objectId;
    delete json._id;
    delete json.objectId;
    if (!__cache__[clazz.typeKey]) {
      __cache__[clazz.typeKey] = {};
    }
    if (Ember.isNone(record)) {
      if (!__cache__[clazz.typeKey][json.id]) {
        record = clazz.create();
      } else {
        record = __cache__[clazz.typeKey][json.id];
      }
    }
    record.merge(json);
    __cache__[clazz.typeKey][json.id] = record;
    this.normalize(record, record.get('modelData'));
    record.set('status', 'persistent');
    return record;
  },

  __pull: function(typeKey, id) {
    var record;
    if ((record = __cache__[typeKey][id])) {
      record.set('status', 'distroyed');
      return delete __cache__[typeKey][id];
    }
  }
});
