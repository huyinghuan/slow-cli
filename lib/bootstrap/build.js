(function() {
  var $current, buildFile, end, _build, _fs, _path, _pathJudge, _utils_file;

  _fs = require('fs');

  _pathJudge = require('path-judge');

  _path = require('path');

  _utils_file = sload('utils/file');

  _build = require('./build/index');

  $current = SLOW.cwd;

  end = function() {
    return process.exit(1);
  };

  buildFile = function(file) {
    var list, next, path;
    path = file.replace($current + "/", "");
    list = _build.getPipeList();
    next = function(filename, buildFilename) {
      var build;
      if (!list.length) {
        return;
      }
      build = list.shift();
      return build(filename, buildFilename, next);
    };
    return next(path, path);
  };

  module.exports = function(program, next) {
    var allFiles, filename, _i, _len;
    if (!program.build) {
      return next();
    }
    console.log('Building...'.blue);
    allFiles = _utils_file.getAllFile($current);
    console.log(allFiles);
    end();
    for (_i = 0, _len = allFiles.length; _i < _len; _i++) {
      filename = allFiles[_i];
      buildFile(filename);
    }
    return console.log('Build complete!'.green);
  };

}).call(this);
