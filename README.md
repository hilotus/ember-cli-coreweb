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
501: Ajax should use promises, received 'success' or 'error' callback

// api-service
502: responseJson is undefined
503: js error in send request progress promise

// model
511: You can not commit a distroyed record.

// store
521: 'The record (id: ' + id + ', modelTypeKey: ' + modelTypeKey + ') is not exist.'
```
