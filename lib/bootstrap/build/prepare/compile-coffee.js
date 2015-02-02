(function() {
  var $buildTarget, $cwd, _coffee, _doBuildCommon, _fs, _fse, _path, _utils_file;

  _path = require('path');

  _coffee = require('coffee-script');

  _fse = require('fs-extra');

  _fs = require('fs');

  _utils_file = sload('utils/file');

  _doBuildCommon = sload('bootstrap/build/index').doBuildCommon;

  $cwd = SLOW.cwd;

  $buildTarget = SLOW.build.target;

  module.exports = function(filename, buildFilename, next) {
    var factory;
    factory = function(filename) {
      var buildTargetFilePath, buildTargetFilename, content;
      console.log("coffee compile " + filename);
      buildTargetFilename = _utils_file.replaceFileExt(filename, "js");
      buildTargetFilePath = _path.join($buildTarget, buildTargetFilename);
      _fse.ensureFileSync(buildTargetFilePath);
      content = _fs.readFileSync(_path.join($cwd, filename), {
        encoding: "utf8"
      });
      _fse.outputFileSync(buildTargetFilePath, _coffee.compile(content));
      return next(filename, buildTargetFilePath);
    };
    return _doBuildCommon(filename, buildFilename, 'coffeeCompile', next, factory);
  };

}).call(this);
