(function() {
  var getBootStraps, _fs, _path;

  _fs = require('fs');

  _path = require('path');

  getBootStraps = function() {
    var fileName, filePath, files, queue, _i, _len;
    queue = [];
    files = _fs.readdirSync(__dirname);
    for (_i = 0, _len = files.length; _i < _len; _i++) {
      fileName = files[_i];
      filePath = _path.join(__dirname, fileName);
      if (filePath === __filename) {
        continue;
      }
      if (_fs.statSync(filePath).isFile()) {
        queue.push(require(filePath));
      }
    }
    return queue;
  };

  module.exports = function(program) {
    var next, straps;
    straps = getBootStraps();
    next = function() {
      var config;
      config = straps.pop();
      if (config) {
        return config(program, next);
      }
    };
    return next();
  };

}).call(this);
