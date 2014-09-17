
/*
  响应.js请求
 */

(function() {
  var _async, _coffee, _fs, _mime, _utils_file;

  _mime = require('mime');

  _utils_file = require('../utils/file');

  _fs = require('fs');

  _async = require('async');

  _coffee = require('coffee-script');

  module.exports = function(req, resp, next) {
    var filePath, flag, mime, pathName, queue;
    pathName = req.client.pathName;
    mime = _mime.lookup(pathName);
    if (mime !== 'application/javascript') {
      return next();
    }
    resp.doCache();
    filePath = _utils_file.getFilePath(pathName);
    flag = _fs.existsSync(filePath);
    if (flag) {
      return resp.sendFile(filePath);
    }
    filePath = filePath.replace(/(\.js)$/, '.coffee');
    if (!_fs.existsSync(filePath)) {
      next();
    }
    queue = [];
    queue.push(function(cb) {
      return _fs.readFile(filePath, {
        encoding: 'utf8'
      }, function(err, data) {
        return cb(err, data);
      });
    });
    queue.push(function(content, cb) {
      var compiled;
      compiled = _coffee.compile(content);
      return cb(null, compiled);
    });
    return _async.waterfall(queue, function(err, result) {
      if (err) {
        return resp.throwsServerError();
      }
      return resp.sendContent(result, mime);
    });
  };

}).call(this);