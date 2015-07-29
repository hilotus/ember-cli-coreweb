import Ember from 'ember';
import ParseAjax from 'ember-cli-coreweb/mixins/parse-ajax';

export default CW.Adapter.extend(ParseAjax, {
  applicationId: '4f3ATEailRoi1A49sh4vlNppWKk8G8xf6ThymKkG',
  restApiKey: 'm2CUMzzcTkqZLTR2v7BVbXLIg9vAzqAxWYVUvyjm',

  getEndPoint: function (modelTypeKey) {
    modelTypeKey = this._super(modelTypeKey);
    return modelTypeKey.match(/User/) ? "users" : modelTypeKey;
  }
});
