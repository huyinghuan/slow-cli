(function() {
  var $buildTarget, $cwd, _doBuildCommon, _fs, _fse, _less, _path, _utils_file;

  _path = require('path');

  _less = require('less');

  _fse = require('fs-extra');

  _fs = require('fs');

  _utils_file = sload('utils/file');

  _doBuildCommon = sload('bootstrap/build/index').doBuildCommon;

  $cwd = process.cwd();

  $buildTarget = SLOW._config_.build.target;

  module.exports = function(filename, buildFilename, next) {
    var factory;
    factory = function(filename) {
      var buildTargetFilePath, buildTargetFilename, content;
      buildTargetFilename = _utils_file.replaceFileExt(filename, "css");
      buildTargetFilePath = _path.join($buildTarget, buildTargetFilename);
      _fse.ensureFileSync(buildTargetFilePath);
      content = _fs.readFileSync(_path.join($cwd, filename), {
        encoding: "utf8"
      });
      return _less.render(content, function(e, css) {
        _fse.outputFileSync(buildTargetFilePath, css);
        return next(filename, buildTargetFilePath);
      });
    };
    return _doBuildCommon(filename, buildFilename, 'lessCompile', next, factory);
  };

}).call(this);
