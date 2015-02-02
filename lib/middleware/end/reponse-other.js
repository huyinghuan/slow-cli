
/*
  响应静态资源请求
 */

(function() {
  var _fs, _utils_file;

  _utils_file = sload('utils/file');

  _fs = require('fs');

  module.exports = function(req, resp, next) {
    var filePath, pathName, state;
    pathName = req.client.pathName;
    filePath = _utils_file.getFilePath(pathName);
    if (!_fs.existsSync(filePath)) {
      return next();
    }
    state = _fs.statSync(filePath);
    if (state.isFile()) {
      resp.doCache();
      return resp.sendFile(filePath);
    }
    if (state.isDirectory()) {
      return next();
    }
    return next();
  };

}).call(this);
