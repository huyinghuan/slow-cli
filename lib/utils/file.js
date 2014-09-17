
/*
  文件操作相关
 */

(function() {
  var File, compressibleQueue, initCompressibleQueue, _chokidar, _isGzip, _isWatch, _mime, _path;

  _path = require('path');

  _mime = require('mime');

  _chokidar = require('chokidar');

  _isGzip = SLOW.base.gzip;

  _isWatch = SLOW.base.isWatchFile;

  File = module.exports = {};

  compressibleQueue = [];

  initCompressibleQueue = function() {
    var ext, queue, _i, _len, _results;
    queue = ['.js', '.css'];
    _results = [];
    for (_i = 0, _len = queue.length; _i < _len; _i++) {
      ext = queue[_i];
      _results.push(compressibleQueue.push(_mime.lookup(ext)));
    }
    return _results;
  };

  initCompressibleQueue();

  File.getFilePath = function(relativePath) {
    return _path.join(SLOW.cwd, relativePath);
  };

  File.compressible = function(fileMime) {
    var mime, _i, _len;
    if (!_isGzip) {
      return false;
    }
    for (_i = 0, _len = compressibleQueue.length; _i < _len; _i++) {
      mime = compressibleQueue[_i];
      if (fileMime === mime) {
        return true;
      }
    }
    return false;
  };

  File.watch = function(cb) {
    var cwd, options, watcher;
    if (!_isWatch) {
      return;
    }
    console.log('watch file is working...');
    options = {
      ignored: /[\/\\]\./,
      persistent: true
    };
    cwd = SLOW.cwd;
    watcher = _chokidar.watch(cwd, options);
    return cb(function(socket) {
      return watcher.on('change', function(path) {
        return socket.emit('file-change');
      });
    });
  };

  File.cwd = function() {
    return SLOW.cwd;
  };

}).call(this);