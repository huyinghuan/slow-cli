(function() {
  module.exports = {
    "version": "v1.0",
    "environment": "develop",
    "develop": {
      "port": 3000,
      "base": {
        "index": "index.html",
        "cache-time": 60 * 60 * 24 * 7,
        "gzip": true,
        "isWatchFile": true,
        "showResponseTime": true
      },
      "proxy": false,
      "error": {
        "403": ''
      },
      "log": {
        "log2console": true,
        "timestamp": false,
        "levelShow": true,
        "lineInfo": false,
        "log2file": false
      }
    },
    "product": require('./product-config'),

    /*项目打包时会读取该选项的配置 */
    "build": require('./build-config'),
    "WebGlobal": require('./web-global')
  };

}).call(this);
