
/*
  响应.html .hbs请求
 */

(function() {
  var _fs, _mime, _utils_file, _utils_handlebar;

  _mime = require('mime');

  _utils_file = require('../utils/file');

  _fs = require('fs');

  _utils_handlebar = require('../utils/handlebar');

  module.exports = function(req, resp, next) {
    var filePath, flag, mime, pathName;
    pathName = req.client.pathName;
    mime = _mime.lookup(pathName);
    if (mime !== 'text/html') {
      return next();
    }
    filePath = _utils_file.getFilePath(pathName);
    flag = _fs.existsSync(filePath);
    if (!flag) {
      filePath = filePath.replace(/(\.html)$/, '.hbs');
      if (!_fs.existsSync(filePath)) {
        return next();
      }
    }
    return _utils_handlebar.compileFile(filePath, function(err, content) {
      if (err) {
        return resp.throwsServerError();
      }
      return resp.sendContent(content, mime);
    });
  };

}).call(this);
