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
    return _utils_file.watch(function(filePath) {
      filePath = filePath.replace(SLOW.cwd, '');
      filePath = filePath.replace(/\.hbs$/, '.html');
      filePath = filePath.replace(/\.less/, '.css');
      filePath = filePath.replace(/\.coffee$/, '.js');
      if (filePath === ("/" + SLOW.base.index)) {
        filePath = '/';
      }
      return _io.sockets.emit('file-change', filePath);
    });
  };

  if (!SLOW.isProduct()) {
    initWatchFile();
  }

  server.listen(port);

  console.log("slow-cli version is " + SLOW.version);

  console.log("Server enviroment is '" + environment + "'");

  console.log("Server running at http://127.0.0.1:" + port + "/");

}).call(this);
