module.exports =
  "version": "" #编译的工程版本 #当读使用编译工程配置文件时 需要指定
  "WebGlobal": require './web-global'  #编译的工程全局变量 #当读使用编译工程配置文件时 需要指定
  "target": "build" #打包文件存放的文件夹.支持绝对路径和相对路径(相对于运行slow的根目录)
  ###
  以下配置(出最后一个ignore外)的值均为一个对象，包含 include 和 ignore 字段。
    其中 include表示将要处理的文件，
      ignore 表示要忽略的文件， 该文件只是在当前处理中被跳过，依然会进入下一个处理程序
      ignore 规则优于 include 规则。 字段的值可以为单个元素或者数组或空
    当值为 单个元素或者数组时， 相当于给对象include的值
     eg.  mincss: /\s+/  ===  mincss:{include: /\s+/}
  ###
  #需要进行压缩的文件 仅对于js和css
  "mincss":
  #需要包含的文件
  #默认值 所有js和css全部进行压缩, 所有压缩过的跳过
    "include": /.+\.(less|css)$/
    "ignore": [/.+(\.min\.css)$/] #已经压缩过的可以忽略。
    "options":{} #clean-css config
  ###
  see https://github.com/mishoo/UglifyJS2 API Reference
  ###
  "minjs":
    "include": /.+\.(js|coffee)$/
    "ignore": [/.+(\.min\.js)$/] #已经压缩过的可以忽略。
    "options":
      "mangle": false #是否压缩变量名
      "compress": {} #see http://lisperator.net/uglifyjs/compress
  "hbsCompile":
    "include": /.+(\.hbs)$/ #需要进行complie的文件
  "coffeeCompile": /.+(.coffee)$/
  "lessCompile": /.+(.less)$/
  #被直接忽视的文件， 不会进入文件处理，也不会被拷贝
  "ignore": [/^(\.slow).+/, /.*(\.gitignore)$/, /^\..+/] #表达式数组或者单个表达式