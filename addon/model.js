import Ember from 'ember';

/*
  how to use model
  var m = Model.create();
  m.setVal('name', 'wluo');  ==> this will save name in modelData;
  m.save();  ==> then, the name will save in model as a property.
  var m = store.find('modelType', id);
  m.setVal('name', 'wluo11'); ==> this will save name in changeData and modelData.name is wluo11,
                                  but m.get('name') is wluo.
  m.save();  ==> then changeData is empty, and m.get('name') is wluo11
  It's important!!!
  All of above, only after saving success, we will update model instance properties.
*/

var Model = Ember.Object.extend({
  init: function() {
    this._super.apply(this, arguments);
    this.set('modelData', {});
    this.set('changeData', {});
  },

  // make sure store is cw.store
  store: null,

  status: 'new',

  isNew: Ember.computed('status', function() {
    return this.status === 'new';
  }),

  isPersistent: Ember.computed('status', function() {
    return this.status === 'persistent';
  }),

  isDistroyed: Ember.computed('status', function() {
    return this.status === 'distroyed';
  }),

  /*
    merge diffrences between server and modelData after create or update.
    call after find and save
    you can see in store.js
  */
  merge: function(json) {
    Ember.merge(this.modelData, json);
    this.clearChanges();
    this.set('status', 'persistent');
  },

  toJSON: function() {
    return this.modelData;
  },

  setVal: function(keyName, value) {
    var vs;
    if (this.get('isDistroyed')) {
      throw new Ember.Error('You can not set value for distroyed record.');
    }

    if (value instanceof Ember.Object) {
      vs = value.get('id');
    } else if (Ember.isArray(value)) {
      vs = value.map(function(v) {
        if (v instanceof Ember.Object) {
          return v.get('id');
        } else {
          return v;
        }
      });
    } else {
      vs = value;
    }

    if (this.get('isPersistent')) {
      this.set("changeData." + keyName, vs);
    } else {
      this.set("modelData." + keyName, vs);
    }

    return this;
  },

  setVals: function(values) {
    var key, self, value;
    if (this.get('isDistroyed')) {
      throw new Ember.Error('You can not set value for distroyed record.');
    }

    self = this;
    for (key in values) {
      value = values[key];
      self.setVal(key, value);
    }
    return self;
  },

  getVal: function(keyName) {
    return this.get("modelData." + keyName);
  },

  getTypeKey: function() {
    return this.constructor.typeKey;
  },

  getChanges: function() {
    var belongTo = [], hasMany = [];

    var schema = this.constructor.schema,
      modelData = this.modelData,
      self = this,
      changes = {},
      key;

    for (key in schema.belongTo) {
      belongTo.push(key);
    }
    for (key in schema.hasMany) {
      hasMany.push(key);
    }

    var changed, tmpValue, tmpDataArr;
    for (key in modelData) {
      if (belongTo.contains(key)) {
        changed = self.get(key + ".id") !== self.get("modelData." + key);
        tmpValue = self.get(key + ".id");
      } else if (hasMany.contains(key)) {
        tmpValue = self.get(key).map(function(value) {
          return value.get('id');
        });
        tmpDataArr = self.get("modelData." + key);
        changed = !(Ember.$(tmpValue).not(tmpDataArr).length === 0 && Ember.$(tmpDataArr).not(tmpValue).length === 0);
      } else {
        changed = self.get(key) !== self.get("modelData." + key);
        tmpValue = self.get(key);
      }

      if (changed) {
        changes[key] = tmpValue;
      }
      changed = false;
    }

    return changes;
  },

  clearChanges: function() {
    return this.set('changeData', {});
  },

  discardChanges: function() {
    return this.store.normalize(this, this.modelData);
  },

  commitChanges: function() {
    var changes;
    if (!this.get('isPersistent')) {
      this.discardChanges();
      return Ember.RSVP.reject(new Ember.Error('You can not commit an unpersistent record.'));
    }
    this.clearChanges();
    changes = this.getChanges();
    if (Ember.$.isEmptyObject(changes)) {
      return Ember.RSVP.resolve('There is no changes.');
    }
    this.set('changeData', changes);
    return this.save();
  },

  save: function() {
    var self;
    if (this.get('isDistroyed')) {
      return Ember.RSVP.reject(new Ember.Error('You can not save distroyed record.'));
    }
    self = this;
    if (this.get('isNew')) {
      return this.store.createRecord(this.getTypeKey(), this.modelData, self).then(function() {
        return Ember.RSVP.resolve();
      });
    } else {
      return this.store.updateRecord(this.getTypeKey(), this.get('id'), this.changeData).then(function() {
        self.clearChanges();
        return Ember.RSVP.resolve();
      }, function(err) {
        self.discardChanges();
        return Ember.RSVP.reject(err);
      });
    }
  },

  "delete": function() {
    return this.store.destroyRecord(this.getTypeKey(), this.get('id')).then(function() {
      return Ember.RSVP.resolve();
    });
  }
});

/*
  {
    typeKey: 'user'
    schema: {
      'belongTo': {'creator': 'user', 'category': 'term'},
      'hasMany': {'tags': 'term', 'comments': 'comment'}
    }
  }
*/
Model.reopenClass({
  typeKey: '',
  schema: {
    belongTo: {},
    hasMany: {}
  }
});

export default Model;
