# Ember-cli-coreweb

I removed `ember-disable-prototype-extensions` from default package.json.

## Usage

`npm install --save-dev ember-cli-corweb`

```js
// environment.js
ENV = {
  ...
  CW: {
    api: {
      // required
      host: 'http://localhost:9292',
      namespace: '1',
      // optional, (third-part. such as 'parse')
      applicationId: 'xxx',
      restApiKey: 'xxx',
      classPath: 'classes'
    }
  }
  ...
}
```

## TODO List

> How to stop the same ajax get call

For example, you can see the dummy project, when `this.store.find("post")`, the post has a `creator` column is a foreign key to `user model`, it will send several request to get user by `creator`.
