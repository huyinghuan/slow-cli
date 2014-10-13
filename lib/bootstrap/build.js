(function() {
  var $current, buildFile, checkLegalProject, end, _build, _fs, _utils_file;

  _fs = require('fs');

  _utils_file = require('../utils/file');

  _build = require('./build/index');

  $current = SLOW.cwd;

  end = function() {
    return process.exit(1);
  };

  checkLegalProject = function(program) {
    if (_fs.existsSync(_path.join($current, SLOW.identify, "config.js"))) {
      return true;
    }
    console.log('Build stop!'.yellow);
    console.log("Can't build project in SLOW sample".red);
    return false;
  };

  buildFile = function(file) {
    var list, next, path;
    path = file.replace("" + $current + "/", "");
    list = _build.getPipeList();
    next = function(filename, buildFilename) {
      var build;
      build = list.shift();
      if (build) {
        return build(filename, buildFilename, next);
      }
    };
    return next(path, path);
  };

  module.exports = function(program, next) {
    var allFils, filename, _i, _len;
    if (!program.build) {
      return next();
    }
    console.log('Building...'.blue);
    if (!checkLegalProject(program)) {
      return end();
    }
    allFils = _utils_file.getAllFile($current);
    for (_i = 0, _len = allFils.length; _i < _len; _i++) {
      filename = allFils[_i];
      buildFile(filename);
    }
    console.log('Build complete!'.green);
    return end();
  };

}).call(this);
