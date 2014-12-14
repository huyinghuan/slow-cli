(function() {
  var getProxyURL, logProxyInfo, proxySetting, _, _httpProxy;

  _ = require('lodash');

  proxySetting = SLOW.proxy;

  _httpProxy = require('http-proxy').createProxyServer();

  logProxyInfo = function() {
    var proxy, proxyURL, queue, _i, _len, _results;
    if (!proxySetting) {
      return;
    }
    queue = [].concat(proxySetting);
    _results = [];
    for (_i = 0, _len = queue.length; _i < _len; _i++) {
      proxy = queue[_i];
      proxyURL = proxy.options.target || proxy.option.forward;
      _results.push(console.log("Server proxy " + proxy.path + " to " + proxyURL));
    }
    return _results;
  };

  logProxyInfo();

  getProxyURL = function(pathName) {
    var proxy, queue, _i, _len;
    queue = [];
    if (_.isPlainObject(proxySetting)) {
      queue = [proxySetting];
    } else if (_.isArray(proxySetting)) {
      queue = proxySetting;
    }
    for (_i = 0, _len = queue.length; _i < _len; _i++) {
      proxy = queue[_i];
      if (proxy.path.test(pathName)) {
        return proxy;
      }
    }
    return false;
  };

  module.exports = function(req, resp, next) {
    var pathName, proxy, proxyURL;
    pathName = req.client.pathName;
    if (!proxySetting) {
      return next();
    }
    proxy = getProxyURL(pathName);
    if (proxy === false) {
      return next();
    }
    proxyURL = proxy.options.target || proxy.options.forward;
    console.log("" + pathName + " " + req.method + " -> " + proxyURL);
    return _httpProxy.web(req, resp, proxy.options, function(e) {
      return resp.throwsServerError();
    });
  };

}).call(this);
