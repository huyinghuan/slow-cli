(function() {
  var URLExtra;

  URLExtra = require('./utils/url-extra');

  module.exports = function(req, resp, next) {
    var pathName, url;
    url = new URLExtra(req);
    pathName = url.getPathName();
    req.client = {};
    req.client.pathName = pathName === '/' ? SLOW.base.index : pathName;
    return next();
  };

}).call(this);
