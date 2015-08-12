var CWError = (function() {
  function CWError() {
    this.constructor.prototype = Object.create(Error.prototype);
    Error.captureStackTrace(this, this.constructor);
    this.name = this.constructor.name;
    if (arguments.length > 0) {
      this.message = arguments[0];
      this.status = arguments[1] ? arguments[1] : 500;
    }
  }
  return CWError;
})();

export default CWError;
