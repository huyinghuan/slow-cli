module.exports =
  "environment": "develop" #开发环境 product #决定是否控制静态文件缓存
  "build": #项目打包时会读取该选项的配置
    target: "build" #打包文件存放的文件夹.支持绝对路径和相对路径(相对于运行slow的根目录)
    copy: ["*"] #可以直接copy的文件夹
    min: #需要进行压缩的文件 仅对于js和css
      include: "*" #需要包含的文件 #默认值 所有js和css全部进行压缩(排除已经压缩后的.)
      ignore: "*.min.*" #已经压缩过的可以忽略, 此条规则优先于include
    hbsCompile:
      include: "*.hbs" #需要进行complie的文件
      ignore: ""
    coffeeCompile:
      include: "*.coffee"
      ignore: ""
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