
/*
  响应.css请求
 */

(function() {
  var $cwd, cssParserOption, _async, _fs, _less, _mime, _path, _utils_file;

  _mime = require('mime');

  _utils_file = sload('utils/file');

  _fs = require('fs');

  _less = require('less');

  _async = require('async');

  _path = require('path');

  $cwd = SLOW.cwd;

  cssParserOption = module.exports = function(req, resp, next) {
    var filePath, flag, mime, pathName, queue;
    pathName = req.client.pathName;
    mime = _mime.lookup(pathName);
    if (mime !== 'text/css') {
      return next();
    }
    filePath = _utils_file.getFilePath(pathName);
    flag = _fs.existsSync(filePath);
    if (flag) {
      return resp.sendFile(filePath);
    }
    filePath = filePath.replace(/(\.css)$/, '.less');
    if (!_fs.existsSync(filePath)) {
      next();
    }
    cssParserOption = {
      paths: [_path.resolve($cwd, _path.dirname(filePath))]
    };
    queue = [];
    queue.push(function(cb) {
      return _fs.readFile(filePath, {
        encoding: 'utf8'
      }, function(err, data) {
        return cb(err, data);
      });
    });
    queue.push(function(content, cb) {
      return _less.render(content, cssParserOption).then(function(output) {
        return cb(null, output.css);
      })["catch"](function(e) {
        console.error(e);
        return cb(e);
      });
    });
    return _async.waterfall(queue, function(err, result) {
      if (err) {
        return resp.throwsServerError();
      }
      return resp.sendContent(result, mime);
    });
  };

}).call(this);
