(function() {
  var $buildTarget, $cwd, cssParser, getCssParser, _doBuildCommon, _fs, _fse, _less, _path, _utils_file;

  _path = require('path');

  _less = require('less');

  _fse = require('fs-extra');

  _fs = require('fs');

  _utils_file = sload('utils/file');

  _doBuildCommon = sload('bootstrap/build/index').doBuildCommon;

  $cwd = process.cwd();

  $buildTarget = SLOW._config_.build.target;

  getCssParser = function() {
    var dir, dirs, queue, _i, _len, _ref;
    dirs = ((_ref = SLOW._config_.common) != null ? _ref.lessImportDiretory : void 0) || [];
    dirs = [].concat(dirs);
    queue = [];
    for (_i = 0, _len = dirs.length; _i < _len; _i++) {
      dir = dirs[_i];
      queue.push(_path.join(process.cwd(), dir));
    }
    console.log(queue);
    return new _less.Parser({
      paths: queue
    });
  };

  cssParser = getCssParser();

  module.exports = function(filename, buildFilename, next) {
    var factory;
    factory = function(filename) {
      var buildTargetFilePath, buildTargetFilename, content;
      console.log("less parse " + filename);
      buildTargetFilename = _utils_file.replaceFileExt(filename, "css");
      buildTargetFilePath = _path.join($buildTarget, buildTargetFilename);
      _fse.ensureFileSync(buildTargetFilePath);
      content = _fs.readFileSync(_path.join($cwd, filename), {
        encoding: "utf8"
      });
      return cssParser.parse(content, function(e, css) {
        _fse.outputFileSync(buildTargetFilePath, css.toCSS());
        return next(filename, buildTargetFilePath);
      });
    };
    return _doBuildCommon(filename, buildFilename, 'lessCompile', next, factory);
  };

}).call(this);
