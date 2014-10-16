(function() {
  var minOptions, _CleanCSS, _doBuildCommon, _fs, _fse, _path, _ref;

  _path = require('path');

  _fs = require('fs');

  _fse = require('fs-extra');

  _CleanCSS = require('clean-css');

  _doBuildCommon = require('./../index').doBuildCommon;

  minOptions = (_ref = SLOW._config_.build.mincss) != null ? _ref.options : void 0;

  module.exports = function(filename, buildFilename, next) {
    var factory;
    factory = function() {
      var minimized, source;
      source = _fs.readFileSync(buildFilename, 'utf8');
      minimized = new _CleanCSS(minOptions).minify(source);
      _fse.outputFileSync(buildFilename, minimized);
      return next(filename, buildFilename);
    };
    return _doBuildCommon(filename, buildFilename, 'mincss', next, factory);
  };

}).call(this);
