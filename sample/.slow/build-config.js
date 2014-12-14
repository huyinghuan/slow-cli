(function() {
  module.exports = {
    "target": "build",

    /*
    以下配置(出最后一个ignore外)的值均为一个对象，包含 include 和 ignore 字段。
      其中 include表示将要处理的文件，
        ignore 表示要忽略的文件， 该文件只是在当前处理中被跳过，依然会进入下一个处理程序
        ignore 规则优于 include 规则。 字段的值可以为单个元素或者数组或空
      当值为 单个元素或者数组时， 相当于给对象include的值
       eg.  mincss: /\s+/  ===  mincss:{include: /\s+/}
     */
    "mincss": {
      "include": /.+\.(less|css)$/,
      "ignore": [/.+(\.min\.css)$/],
      "options": {}
    },

    /*
    see https://github.com/mishoo/UglifyJS2 API Reference
     */
    "minjs": {
      "include": /.+\.(js|coffee)$/,
      "ignore": [/.+(\.min\.js)$/],
      "options": {
        "mangle": false,
        "compress": {}
      }
    },
    "hbsCompile": {
      "include": /.+(\.hbs)$/
    },
    "coffeeCompile": /.+(.coffee)$/,
    "lessCompile": /.+(.less)$/,
    "ignore": [/^(\.slow).+/, /.*(\.gitignore)$/, /^\..+/]
  };

}).call(this);
