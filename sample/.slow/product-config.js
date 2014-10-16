(function() {
  module.exports = {
    "port": 3000,
    "base": {
      "index": "index.html",
      "cache-time": 60 * 60 * 24 * 7,
      "gzip": true,
      "isWatchFile": true,
      "showResponseTime": false
    },
    "proxy": false,
    "error": {
      "403": ''
    }
  };

}).call(this);
