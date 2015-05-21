`import Ember from 'ember'`

# how to use model
# var m = Model.create();
# m.setVal('name', 'wluo');  ==> this will save name in modelData;
# m.save();  ==> then, the name will save in model as a property.
# var m = store.find('modelType', id);
# m.setVal('name', 'wluo11'); ==> this will save name in changeData and modelData.name is wluo11,
#                                 but m.get('name') is wluo.
# m.save();  ==> then changeData is empty, and m.get('name') is wluo11
# It's important!!!
# All of above, only after saving success, we will update model instance properties.

Model = Ember.Object.extend
  init: ->
    @_super()
    @set 'modelData', {}
    @set 'changeData', {}

  # make sure store is cw.store
  store: null

  status: 'new'

  isNew: Ember.computed 'status', ->
    @status is 'new'

  isPersistent: Ember.computed 'status', ->
    @status is 'persistent'

  isDistroyed: Ember.computed 'status', ->
    @status is 'distroyed'

  # merge diffrences between server and modelData after create or update.
  # call after find and save
  # you can see in store.js
  merge: (json) ->
    Ember.merge @modelData, json
    @clearChanges()
    @set 'status', 'persistent'

  setVal: (keyName, value) ->
    throw new Error 'You can not set value for distroyed record.' if @get('isDistroyed')

    # 1. value is a Model instance, get value's id
    # 2. value is a Array, get it's element(ids) array.
    if value instanceof Ember.Object
      vs = value.get('id');
    else if Ember.isArray value
      vs = value.map (v) ->
        if v instanceof Ember.Object then v.get('id') else v
    else
      vs = value

    # when the status is persistent, only after saving success, update the changes to modelData.
    if @get('isPersistent')
      @set "changeData.#{keyName}", vs
    else
      @set "modelData.#{keyName}", vs
    @

  setVals: (values) ->
    throw new Error 'You can not set value for distroyed record.' if @get('isDistroyed')

    self = @
    for key, value of values
      self.setVal key, value
    self

  getVal: (keyName) ->
    @get "modelData.#{keyName}"

  getTypeKey: () ->
    @constructor.typeKey

  getCapitalizeTypeKey: ->
    @constructor.typeKey.classify()


  getChanges: ->
    belongTo = hasMany = []
    schema = @constructor.schema
    self = @
    changes = {}

    for key, value of schema.belongTo
      belongTo.push key

    for key, value of schema.hasMany
      hasMany.push key

    for key, value of @modelData
      if belongTo.contains key
        changed = self.get "#{key}.id" isnt self.get "modelData.#{key}"
        tmpValue = self.get "#{key}.id"
      else if hasMany.contains key
        tmpValue = self.get(key).map (v) ->
          v.get('id')
        tmpDataArr = self.get "modelData.#{key}"
        # returns true, both the arrays are same even if the elements are in different order.
        changed = !($(tmpValue).not(tmpDataArr).length is 0 and $(tmpDataArr).not(tmpValue).length is 0)
      else
        changed = self.get key isnt self.get "modelData.#{key}"
        tmpValue = self.get key

      if changed
        changes[key] = tmpValue

      changed = false

    changes

  clearChanges: ->
    @set 'changeData', {}

  # discard all changes
  discardChanges: ->
    @store.__normalize @, @modelData

  # commit all changes
  commitChanges: ->
    unless !@get('isPersistent')
      @discardChanges()
      throw new Error 'You can not commit an unpersistent record.'

    @clearChanges()
    changes = @getChanges()
    if !$.isEmptyObject(changes)
      @set 'changeData', changes
      @save()
    Ember.RSVP.reject {error: 'There are no changes.'}

  save: ->
    throw new Error('You can not save distroyed record.') if @get('isDistroyed')

    clazz = @constructor
    self = @
    if @get('isNew')
      @store.createRecord(clazz, @modelData).then (json) ->
        self.store.push clazz, json, self
        Ember.RSVP.resolve self
      , (reason) ->
        Ember.RSVP.reject reason
    else
      @store.updateRecord(clazz, @get('id'), @changeData).then (json) ->
        self.store.reload self.getTypeKey(), json, self
        Ember.RSVP.resolve self
      , (reason) ->
        self.discardChanges()
        Ember.RSVP.reject reason

  delete: ->
    clazz = @constructor
    self = @
    return @store.destroyRecord(clazz, @get('id')).then ->
      self.set 'status', 'distroyed'
      self.store.pull self.getTypeKey(), self.get('id')
      Ember.RSVP.resolve self
    , (reason) ->
      return Ember.RSVP.reject reason

# schema: {
#   'belongTo': {'creator': 'user', 'category': 'term'},
#   'hasMany': {'tags': 'term', 'comments': 'comment'}
# }
Model.reopenClass
  typeKey: ''
  schema:
    belongTo: {}
    hasMany: {}

`export default Model`
