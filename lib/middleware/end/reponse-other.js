
/*
  响应静态资源请求
 */

(function() {
  var _fs, _utils_file;

  _utils_file = sload('utils/file');

  _fs = require('fs');

  module.exports = function(req, resp, next) {
    var filePath, flag, pathName;
    pathName = req.client.pathName;
    filePath = _utils_file.getFilePath(pathName);
    flag = _fs.existsSync(filePath);
    resp.doCache();
    if (flag) {
      return resp.sendFile(filePath);
    }
    return next();
  };

}).call(this);
