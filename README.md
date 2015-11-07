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
      // optional, (third-part. such as 'parse api')
      parse: true,
      applicationId: 'xxx',
      restApiKey: 'xxx',
      classPath: 'classes'
    }
  }
  ...
}
```

## Error Code

```
// ic-ajax
521: Ajax should use promises, received 'success' or 'error' callback

// api-service
522: json response is undefined in ajax.

// model
531: You can not commit a distroyed record.
532: There is no changes to save.

// store
541: 'The record (id: ' + id + ', modelTypeKey: ' + modelTypeKey + ') is not exist.'
```
