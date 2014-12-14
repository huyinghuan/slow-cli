(function() {
  var Middleware, addMiddleware, getMiddleware, initMiddlewareStack, scanHeadMiddleware, scanMiddleware, wares, _, _fs, _path, _router, _sload;

  _fs = require('fs');

  _path = require('path');

  _sload = require('sload');

  _ = require('lodash');

  _router = sload('router');

  wares = [];

  addMiddleware = function(ware) {
    if (_.isArray(ware)) {
      return wares = wares.concat(ware);
    } else {
      return wares.push(ware);
    }
  };

  scanMiddleware = function(middleDirector) {
    var dir, list;
    dir = _path.join(__dirname, middleDirector);
    list = _sload.scan(dir);
    return addMiddleware(list);
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
