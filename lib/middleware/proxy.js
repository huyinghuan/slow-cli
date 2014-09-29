(function() {
  var _httpProxy;

  _httpProxy = require('http-proxy').createProxyServer();

  module.exports = function(req, resp, next) {
    var pathName, proxyPath, proxySetting;
    pathName = req.client.pathName;
    proxySetting = SLOW.proxy;
    if (!proxySetting) {
      return next();
    }
    proxyPath = proxySetting.path;
    if (!proxyPath.test(pathName)) {
      return next();
    }
    return _httpProxy.web(req, resp, proxySetting.options, function() {
      return resp.throwsServerError();
    });
  };

}).call(this);
