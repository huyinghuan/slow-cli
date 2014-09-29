(function() {
  module.exports = {
    "environment": "develop",
    "build": {
      target: "build",
      copy: ["*"],
      min: {
        include: "*",
        ignore: "*.min.*"
      },
      hbsCompile: {
        include: "*.hbs",
        ignore: ""
      },
      coffeeCompile: {
        include: "*.coffee",
        ignore: ""
      }
    },
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
      },
      "log": {
        "log2console": true,
        "timestamp": false,
        "levelShow": true,
        "lineInfo": false,
        "log2file": false
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
      "proxy": false,
      "error": {
        "403": ''
      }
    }
  };

}).call(this);
