(function() {
  var $buildTarget, $cwd, _doBuildCommon, _fse, _handlebar, _path, _utils_file;

  _path = require('path');

  _handlebar = sload('utils/handlebar');

  _fse = require('fs-extra');

  _utils_file = sload('utils/file');

  _doBuildCommon = sload('bootstrap/build/index').doBuildCommon;

  $cwd = process.cwd();

  $buildTarget = SLOW._config_.build.target;

  module.exports = function(filename, buildFilename, next) {
    var factory;
    factory = function(filename) {
      var buildTargetFilePath, buildTargetFilename, content;
      console.log("Handlebar parse " + filename);
      buildTargetFilename = _utils_file.replaceFileExt(filename, "html");
      buildTargetFilePath = _path.join($buildTarget, buildTargetFilename);
      _fse.ensureFileSync(buildTargetFilePath);
      content = _handlebar.compileFileSync(_path.join($cwd, filename));
      _fse.outputFileSync(buildTargetFilePath, content);
      return next(filename, buildTargetFilePath);
    };
    return _doBuildCommon(filename, buildFilename, 'hbsCompile', next, factory);
  };

}).call(this);
