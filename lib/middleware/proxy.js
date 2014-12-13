(function() {
  var proxyOptions, proxyPath, proxySetting, proxyURL, _httpProxy;

  proxySetting = SLOW.proxy;

  proxyPath = proxySetting.path;

  proxyOptions = proxySetting.options;

  proxyURL = proxyOptions.target || proxyOptions.forward;

  _httpProxy = require('http-proxy').createProxyServer();

  if (proxyURL) {
    console.log("Server proxy " + proxyPath + " to " + proxyURL);
  }

  module.exports = function(req, resp, next) {
    var pathName;
    pathName = req.client.pathName;
    if (!proxySetting) {
      return next();
    }
    if (!proxyPath.test(pathName)) {
      return next();
    }
    console.log("" + pathName + " " + req.method + " -> " + proxyURL);
    return _httpProxy.web(req, resp, proxyOptions, function(e) {
      console.log(e);
      return resp.throwsServerError();
    });
  };

}).call(this);
