(function() {
  module.exports = {
    "environment": "develop",
    "port": 3000,
    "base": {
      "index": "index.html",
      "cache-time": 60 * 60 * 24 * 7
    },
    "proxy": {
      "path": "/api",
      "redirect": "http://localhost:8001"
    },
    "error": {
      "403": ''
    }
  };

}).call(this);
