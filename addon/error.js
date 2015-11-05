class StandardError extends Error {
  constructor(msg, code=500, isServerError=false) {
    super(msg);
    this.name = this.constructor.name;
    this.message = msg;
    this.code = code;
    this.isServerError = isServerError;
    Error.captureStackTrace(this, this.constructor.name);
  }
}

export class CustomError extends StandardError {
  constructor(message, code, isServerError) {
    super(message, code, isServerError);
  }
}
