import Ember from 'ember';
import { CustomError } from './error';

/**
  how to use model
  var user = User.create();
  user.set('name', 'wluo');  ==> this will save name in modelData;
  user.save();  ==> then, the name will save in model as a property.
  All of above, only after saving success, we will update model instance properties.
**/

var Model = Ember.Object.extend({
  init: function() {
    this._super.apply(this, arguments);

    // the basic data query from api.
    this.set('modelData', {});
  },

  store: null,  // make sure store is cw.store
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

  /**
    merge diffrences between server and modelData after create or update.
    call after find and save
    you can see in store.js
  **/
  merge: function (json) {
    Ember.merge(this.modelData, json);
    this.set('status', 'persistent');
  },

  pull: function () {
    this.set('status', 'distroyed');
  },

  getTypeKey: function () {
    return this.constructor.typeKey;
  },

  getSchema: function () {
    return this.constructor.schema;
  },

  getChanges: function () {
    var changes = {},
      schema = this.getSchema();

    for (var key in schema) {
      // common api, parse api, timestamps(createdAt, updatedAt)
      if (key === 'id' || key === 'objectId' || schema[key].type === 'timestamps') {
        continue;
      }

      if (schema[key].type.match(/string|boolean|number/)) {
        if (this.get('isNew')) {
          changes[key] = this.get(key);
        } else if (this.get('isPersistent')) {
          if (this.get(key) !== this.get('modelData.' + key)) {
            changes[key] = this.get(key);
          }
        }
      } else if (schema[key].type === 'belongTo') {
        if (this.get('isNew')) {
          changes[key] = this.get(key + '.id');
        } else if (this.get('isPersistent')) {
          if (this.get(key + '.id') !== this.get('modelData.' + key)) {
            changes[key] = this.get(key + '.id');
          }
        }
      } else if (schema[key].type === 'hasMany') {
        if (this.get('isNew')) {
          changes[key] = this.get(key).map(function (item) { return item.get('id'); });
        } else if (this.get('isPersistent')) {
          var value1 = this.get(key).map(function (item) { return item.get('id'); });
          var value2 = this.get('modelData.' + key);
          if (Ember.$(value1).not(value2).length !== 0 || Ember.$(value2).not(value1).length !== 0) {
            changes[key] = value1;
          }
        }
      } else if (schema[key].type === 'embedsIn') {
        changes[key] = this.get(key).getChanges();
        if (Ember.$.isEmptyObject(changes[key])) {
          delete changes[key];
        } else {
          changes[key]['id'] = this.get(key + '.id');
        }
      } else if (schema[key].type === 'embedsMany') {
        changes[key] = [];
        var __changes;
        this.get(key).forEach(function (record) {
          __changes = record.getChanges();
          if (!Ember.$.isEmptyObject(__changes)) {
            __changes['id'] = record.get('id');
            changes[key].push(__changes);
          }
          __changes = null;
        }, this);
      }
    }
    return changes;
  },

  discardChanges: function () {
    return this.normalize();
  },

  save: function () {
    if (this.get('isDistroyed')) {
      return Ember.RSVP.reject(new CustomError('You can not commit a distroyed record.', 531));
    }

    var changes = this.getChanges();
    if (Ember.$.isEmptyObject(changes)) {
      return Ember.RSVP.reject(new CustomError('There is no changes to save.', 532));
    }

    if (this.get('isNew')) {
      return this.store.createRecord(this.getTypeKey(), changes, this);
    } else {
      return this.store.updateRecord(this.getTypeKey(), this.get('id'), changes)
        .catch(function (err) {
          this.discardChanges();
          return Ember.RSVP.reject(err);
        }.bind(this));
    }
  },

  "delete": function() {
    return this.store.destroyRecord(this.getTypeKey(), this.get('id'));
  },

  /**
    setup modelData to record.
  **/
  normalize: function () {
    var schema = this.getSchema();

    for (var key in schema) {
      var value = this.get('modelData.' + key) || schema[key].defaultValue;

      if (schema[key].type.match(/string|number|timestamps/)) {
        this.__normalizeNormal(key, value);
      } else if (schema[key].type === 'boolean') {
        this.__normalizeNormal(key, !!value);
      } else {
        if (value) {
          if (schema[key].type === 'belongTo') {
            this.__normalizeBelongTo(key, value, schema[key].className);
          } else if (schema[key].type === 'hasMany') {
            this.__normalizeHasMany(key, value, schema[key].className);
          } else if (schema[key].type === 'embedsIn') {
            this.__normalizeEmbedsIn(key, value, schema[key].className);
          } else if (schema[key].type === 'embedsMany') {
            this.__normalizeEmbedsMany(key, value, schema[key].className);
          }
        }
      }
    }
  },

  /**
    key of record, className's id, className's modelTypeKey('user')
  **/
  __normalizeBelongTo: function (key, id, className) {
    return this.store.find(className, id)
      .then(function (record) {
        return this.set(key, record);
      }.bind(this));
  },

  __normalizeHasMany: function (key, ids, className) {
    var promises = ids.map(function (id) {
      return this.store.find(className, id);
    }, this);

    this.set(key, []);

    Ember.RSVP.all(promises)
      .then(function (records) {
        this.get(key).pushObjects(records);
      }.bind(this));
  },

  __normalizeEmbedsIn: function (key, obj, className) {
    this.set(key, this.store.push(className, obj));
  },

  __normalizeEmbedsMany: function (key, objs, className) {
    this.set(key, []);

    objs.forEach(function(obj) {
      this.get(key).pushObject(this.store.push(className, obj));
    }, this);
  },

  __normalizeNormal: function (key, value) {
    this.set(key, value);
  }
});

/**
  {
    typeKey: 'user'
    schema: {
      id: {type: 'string'},
      objectId: {type: 'String'},
      title: {type: 'string'},
      creator: {type: 'belongTo', className: 'user'},
      category: {type: 'belongTo', className: 'term'},
      tags: {type: 'hasMany', className: 'term', defaultValue: []},

      field: {type: 'embedsIn', className: 'field'},
      steps: {type: 'embedsMany', className: 'step', defaultValue: []},

      !!!The format of the two columns is YYYY-MM-DDTHH:mm:ss.SSSSZ (UTC Format);
      createdAt: {type: 'timestamps'},
      updatedAt: {type: 'timestamps'}
    }
  }
**/
Model.reopenClass({
  typeKey: '',
  schema: {}
});

export default Model;
