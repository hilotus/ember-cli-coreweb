import { CustomError } from 'ember-cli-coreweb/error';
import { module, test } from 'qunit';

module('Unit | Utility | error');

test('CustomError', function(assert) {
  var error = new CustomError('asd');
  assert.equal(error.message, 'asd');
  assert.equal(error.code, 500);
  assert.notEqual(error.stack, undefined);
  assert.equal(error.name, 'CustomError');
});
