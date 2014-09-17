(function() {
  var environment, initWatchFile, port, server, _http, _middleware, _utils_file;

  _http = require('http');

  _middleware = require('./middleware');

  _utils_file = require('./utils/file');

  port = SLOW.port;

  environment = SLOW.env;

  server = _http.createServer(function(req, res) {
    return _middleware.next(req, res);
  });

  initWatchFile = function() {
    var _io;
    _io = require('socket.io')(server);
    return _utils_file.watch(function(cb) {
      return _io.on('connection', function(socket) {
        return cb(socket);
      });
    });
  };

  if (!SLOW.isProduct()) {
    initWatchFile();
  }

  server.listen(port);

  console.log("Server running at http://127.0.0.1:" + port + "/");

  console.log("Server enviroment is '" + environment + "'");

}).call(this);