(function() {
  var $buildTarget, $cwd, _async, _doBuildCommon, _fs, _fse, _less, _path, _utils_file;

  _path = require('path');

  _less = require('less');

  _fse = require('fs-extra');

  _fs = require('fs');

  _async = require('async');

  _utils_file = sload('utils/file');

  _doBuildCommon = sload('bootstrap/build/index').doBuildCommon;

  $cwd = SLOW.cwd;

  $buildTarget = SLOW.build.target;

  module.exports = function(filename, buildFilename, next) {
    var factory;
    factory = function(filename) {
      var buildTargetFilePath, buildTargetFilename, cssParserOption, queue;
      console.log("less parse " + filename);
      buildTargetFilename = _utils_file.replaceFileExt(filename, "css");
      buildTargetFilePath = _path.join($buildTarget, buildTargetFilename);
      _fse.ensureFileSync(buildTargetFilePath);
      cssParserOption = {
        paths: [_path.resolve($cwd, _path.dirname(filename))]
      };
      console.log(cssParserOption);
      queue = [];
      queue.push(function(cb) {
        return _fs.readFile(_path.join($cwd, filename), {
          encoding: "utf8"
        }, function(err, content) {
          return cb(err, content);
        });
      });
      queue.push(function(content, cb) {
        return _less.render(content, cssParserOption).then(function(output) {
          return cb(null, output.css);
        });
      });
      queue.push(function(css, cb) {
        return _fse.outputFile(buildTargetFilePath, css, function(err) {
          return cb(err);
        });
      });
      return _async.waterfall(queue, function(err) {
        if (err) {
          console.error(err);
        }
        if (!err) {
          return next(filename, buildTargetFilePath);
        }
      });
    };
    return _doBuildCommon(filename, buildFilename, 'lessCompile', next, factory);
  };

}).call(this);
