# Ember-cli-coreweb

* I removed `ember-disable-prototype-extensions` from default package.json, and we can reference the two links
    [https://github.com/ember-cli/ember-cli/issues/3443](https://github.com/ember-cli/ember-cli/issues/3443)
    [http://reefpoints.dockyard.com/2015/03/22/tips-for-writing-ember-addons.html](http://reefpoints.dockyard.com/2015/03/22/tips-for-writing-ember-addons.html)

* TODO:
  1. I cached query Results on browser. If the query conditions is same as past one, it'll not call qeury api.
    There are two way to call api to refresh the cache:
    a. click refresh button.
    b. retrieve data changed notification from server.

* ISSUE:
    1. select-picker is disappear in firefox!!!

* Build && Publish:
    `npm add user`
    `npm publish`

* Usage
  `npm install --save-dev ember-cli-corweb`
  `ember g ember-cli-coreweb`
