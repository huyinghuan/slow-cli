(function() {
  var defaultOptions, minOptions, _, _UglifyJS, _doBuildCommon, _fs, _fse, _path, _ref;

  _path = require('path');

  _fs = require('fs');

  _fse = require('fs-extra');

  _UglifyJS = require("uglify-js");

  _ = require('lodash');

  _doBuildCommon = require('./../index').doBuildCommon;

  defaultOptions = {
    fromString: true
  };

  minOptions = (_ref = SLOW._config_.build.minjs) != null ? _ref.options : void 0;

  _.extend(minOptions, defaultOptions);

  module.exports = function(filename, buildFilename, next) {
    var factory;
    factory = function(filename) {
      var minimized, source;
      source = _fs.readFileSync(buildFilename, 'utf8');
      minimized = _UglifyJS.minify(source, minOptions);
      _fse.outputFileSync(buildFilename, minimized.code);
      return next(filename, buildFilename);
    };
    return _doBuildCommon(filename, buildFilename, 'minjs', next, factory);
  };

}).call(this);
