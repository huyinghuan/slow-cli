
/*
  对 response 的扩展
 */

(function() {
  var _fs, _mime, _utils_file, _zlib;

  _mime = require('mime');

  _fs = require('fs');

  _zlib = require('zlib');

  _utils_file = sload('utils/file');

  module.exports = function(req, resp, next) {
    var doCache, sayNoFound, sendContent, sendFile, throwsServerError;
    sayNoFound = function() {
      resp.statusCode = 404;
      return resp.end('No file found');
    };
    sendFile = function(path) {
      var fileStream, flag, gzip, mime;
      flag = _fs.existsSync(path);
      resp.statusCode = 200;
      if (!flag) {
        return sayNoFound();
      }
      mime = _mime.lookup(path);
      resp.setHeader("Content-Type", mime);
      fileStream = _fs.createReadStream(path);
      if (_utils_file.compressible(mime)) {
        resp.setHeader('content-encoding', 'gzip');
        gzip = _zlib.createGzip();
        return fileStream.pipe(gzip).pipe(resp);
      } else {
        return fileStream.pipe(resp);
      }
    };
    throwsServerError = function() {
      resp.statusCode = 500;
      return resp.end('Server has crash！');
    };
    sendContent = function(content, mime) {
      if (mime == null) {
        mime = "text/plain";
      }
      resp.setHeader("Content-Type", mime);
      resp.statusCode = 200;
      if (_utils_file.compressible(mime)) {
        resp.setHeader('content-encoding', 'gzip');
        return _zlib.gzip(content, function(err, result) {
          resp.write(result, 'utf8');
          return resp.end();
        });
      } else {
        resp.write(content, 'utf8');
        return resp.end();
      }
    };
    doCache = function() {
      resp.setHeader('Cache-Control', "public, max-age=" + SLOW.base['cache-time']);
      return resp.setHeader('Expires', new Date(new Date().getTime() + SLOW.base['cache-time'] * 1000));
    };
    resp.sendFile = sendFile;
    resp.sayNoFound = sayNoFound;
    resp.throwsServerError = throwsServerError;
    resp.sendContent = sendContent;
    resp.doCache = doCache;
    return next();
  };

}).call(this);
