(function() {
  var checkVersion, copyConfig, _colors, _fs, _fse, _path;

  _path = require('path');

  _fse = require('fs-extra');

  _fs = require('fs');

  _colors = require('colors');

  copyConfig = function() {
    var current;
    current = SLOW.$currentDefaultConfigFilePath;
    if (_fs.existsSync(current)) {
      _fse.copySync(current, current + "." + (new Date().getTime()) + ".bak");
    }
    return _fse.copySync(SLOW.$defaultConfigFilePath, current);
  };

  checkVersion = function() {
    var current;
    return current = SLOW.version;
  };

  module.exports = function(program, next) {
    if (!program.update) {
      return next();
    }
    return process.exit(1);
  };

}).call(this);
