(function() {
  module.exports = {
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
      "proxy": {
        "path": /^\/api/,
        "options": {
          "target": "http://localhost:8000"
        }
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
        "isWatchFile": true,
        "showResponseTime": false
      },
      "proxy": {
        "path": /^\/api/,
        "options": {
          "target": "http://localhost:8000"
        }
      },
      "error": {
        "403": ''
      }
    }
  };

}).call(this);
