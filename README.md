# Ember-cli-coreweb

I removed `ember-disable-prototype-extensions` from default package.json, and we can reference the two links [https://github.com/ember-cli/ember-cli/issues/3443](https://github.com/ember-cli/ember-cli/issues/3443), [http://reefpoints.dockyard.com/2015/03/22/tips-for-writing-ember-addons.html](http://reefpoints.dockyard.com/2015/03/22/tips-for-writing-ember-addons.html)

## Usage

`npm install --save-dev ember-cli-corweb`

## TODO List

> How to stop the same ajax get call

For example, you can see the dummy project, when `this.store.find("post")`, the post has a `creator` column is a foreign key to `user model`, it will send several request to get user by `creator`.

> ChangeSet Response

set `defaultModels` in `environment.js`:

```js
// environment.js
ENV.defaultModels = ['User', 'Post', 'Comment']
```

> Use `ember-cli-linker` to import third party packages.

Reference: [https://github.com/ef4/ember-browserify/issues/34](https://github.com/ef4/ember-browserify/issues/34), [https://github.com/ef4/ember-browserify](https://github.com/ef4/ember-browserify)
