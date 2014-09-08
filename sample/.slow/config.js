(function() {
  module.exports = {
    "environment": "develop",
    "develop": {
      "port": 3000,
      "base": {
        "index": "index.html",
        "cache-time": 60 * 60 * 24 * 7,
        "gzip": true,
        "isWatchFile": true
      },
      "proxy": {
        "path": "/api",
        "redirect": "http://localhost:8001"
      },
      "error": {
        "403": ''
      }
    },
    "product": {
      "port": 3000,
      "base": {
        "index": "index.html",
        "cache-time": 60 * 60 * 24 * 7,
        "gzip": true,
        "isWatchFile": true
      },
      "proxy": {
        "path": "/api",
        "redirect": "http://localhost:8001"
      },
      "error": {
        "403": ''
      }
    }
  };

}).call(this);
