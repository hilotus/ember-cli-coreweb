# Ember-cli-coreweb

* I removed `ember-disable-prototype-extensions` from default package.json, and we can reference the two links
    [https://github.com/ember-cli/ember-cli/issues/3443](https://github.com/ember-cli/ember-cli/issues/3443)
    [http://reefpoints.dockyard.com/2015/03/22/tips-for-writing-ember-addons.html](http://reefpoints.dockyard.com/2015/03/22/tips-for-writing-ember-addons.html)

* TODO:
    One. I cached query Results on browser. If the query conditions is same as past one, it'll not call qeury api.
      There are two way to call api to refresh the cache:
      1. click refresh button.
      2. retrieve data changed notification from server.

      Issus: There is a issus about this solution
      1.
