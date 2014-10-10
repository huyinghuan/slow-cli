(function() {
  module.exports = {
    "environment": "develop",
    "build": {
      target: "build",

      /*
         *以下配置均包含 include 和 ignore 字段。
         *其中 include表示将要处理的文件，
         *ignore 表示要忽略的文件， 该文件只是在当前处理中被跳过，依然会进入下一个处理程序
         *ignore 规则优于 include 规则。 字段的值可以为单个元素或者数组或空
         *当省略字段，直接赋值时， 默认为include的值
       */
      min: {
        include: /.+(\.css|\.js)$/,
        ignore: [/.+\.min\.(css|js)$/]
      },
      hbsCompile: {
        include: /.+(\.hbs)$/
      },
      coffeeCompile: /.+(.coffee)$/,
      ignore: /\.slow\/.+/
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
