(function() {
  var Middleware, addMiddleware, getMiddleware, initMiddlewareStack, scanHeadMiddleware, scanMiddleware, wares, _fs, _path, _router;

  _fs = require('fs');

  _path = require('path');

  _router = require('./router');

  wares = [];

  addMiddleware = function(ware) {
    return wares.push(ware);
  };

  scanMiddleware = function(middleDirector) {
    var dir, file, filepath, files, _i, _len;
    dir = _path.join(__dirname, middleDirector);
    files = _fs.readdirSync(dir);
    for (_i = 0, _len = files.length; _i < _len; _i++) {
      file = files[_i];
      filepath = _path.join(dir, file);
      if (_fs.statSync(filepath).isFile()) {
        addMiddleware(require(filepath));
      }
    }
    return 0;
  };

  scanHeadMiddleware = function() {
    return addMiddleware(_router);
  };

  initMiddlewareStack = function() {
    scanMiddleware('middleware/error');
    scanMiddleware('middleware/end');
    scanMiddleware('middleware');
    scanMiddleware('middleware/start');
    return scanHeadMiddleware();
  };

  initMiddlewareStack();

  getMiddleware = function() {
    return wares.concat([]);
  };

  Middleware = module.exports = {};

  Middleware.add = function(ware) {
    return addMiddleware(ware);
  };

  Middleware.next = function(req, resp) {
    var middlewareStack, next;
    middlewareStack = getMiddleware();
    next = function() {
      var middleware;
      middleware = middlewareStack.pop();
      if (middleware) {
        return middleware(req, resp, next);
      }
    };
    return next();
  };

}).call(this);