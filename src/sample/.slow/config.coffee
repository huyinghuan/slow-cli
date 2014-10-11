module.exports =
  "environment": "develop" #开发环境 product #决定是否控制静态文件缓存
  "build": #项目打包时会读取该选项的配置
    target: "build" #打包文件存放的文件夹.支持绝对路径和相对路径(相对于运行slow的根目录)
    ###
      #以下配置均包含 include 和 ignore 字段。
      #其中 include表示将要处理的文件，
      #ignore 表示要忽略的文件， 该文件只是在当前处理中被跳过，依然会进入下一个处理程序
      #ignore 规则优于 include 规则。 字段的值可以为单个元素或者数组或空
      #当省略字段，直接赋值时， 默认为include的值
    ###
    #需要进行压缩的文件 仅对于js和css
    min:
      #需要包含的文件
      #默认值 所有js和css全部进行压缩, 所有压缩过的跳过
      include: /.+(\.css|\.js)$/
      ignore: [/.+\.min\.(css|js)$/] #已经压缩过的可以忽略。
    hbsCompile:
      include: /.+(\.hbs)$/ #需要进行complie的文件
    coffeeCompile: /.+(.coffee)$/
    lessCompile: /.+(.less)$/
    ignore: /\.slow\/.+/ #表达式数组或者单个表达式
  "develop": #开发者模式配置
    "port": 3000 #运行端口
    "base": #基本配置
      "index": "index.html" #默认首页
      "cache-time": 60 * 60 * 24 * 7 #缓存时间
      "gzip": true #是否gzip资源文件
      "isWatchFile": true #是否监控文件变化刷新文件
      "showResponseTime": true #是否显示每个请求的响应时间
    "proxy": #代理配置 #不需要代理 设为false
      "path": /^\/api/ #需要进行代理的路径。支持正则
      "options":
        "target": "http://localhost:8000"
    "error": #错误页面配置
      "403": ''
    "log": #log配置.具体可以参考npm package log4slow的配置(http://github.com/huyinghuan/log4slow)
      "log2console": true,
      "timestamp": false,
      "levelShow": true,
      "lineInfo": false,
      "log2file": false
  "product": #成品配置
    "port": 3000 #运行端口
    "base": #基本配置
      "index": "index.html" #默认首页
      "cache-time": 60 * 60 * 24 * 7 #缓存时间
      "gzip": true
      "isWatchFile": true #在生产环境中该配置无效.也就是不会监控任何文件改变
      "showResponseTime": false #是否显示每个请求的响应时间
    "proxy": false
    "error": #错误页面配置
      "403": ''