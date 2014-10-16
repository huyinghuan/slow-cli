(function() {
  var environment, initWatchFile, port, proxy, server, _EventEmitter, _http, _middleware, _utils_file;

  _http = require('http');

  _middleware = sload('middleware');

  _utils_file = sload('utils/file');

  _EventEmitter = require('events').EventEmitter;

  port = SLOW.port;

  proxy = SLOW.proxy;

  environment = SLOW.env;

  server = _http.createServer(function(req, res) {
    return _middleware.next(req, res);
  });

  initWatchFile = function() {
    var _io;
    _io = require('socket.io')(server);
    return _utils_file.watch(function() {
      return _io.sockets.emit('file-change');
    });
  };

  if (!SLOW.isProduct()) {
    initWatchFile();
  }

  server.listen(port);

  console.log("slow-cli version is " + SLOW.version);

  console.log("Server enviroment is '" + environment + "'");

  console.log("Server running at http://127.0.0.1:" + port + "/");

  if (proxy.options.target) {
    console.log("Server proxy " + proxy.path + " to " + proxy.options.target);
  }

}).call(this);
