module.exports =
  "environment": "develop" #开发环境 product #决定是否控制静态文件缓存
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
  "product": require './product-config'
  ###项目打包时会读取该选项的配置###
  "build": require './build-config'