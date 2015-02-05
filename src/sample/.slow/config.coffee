module.exports =
  "version": "v1.0" #版本号， 将添加在以 import指令 引用的资源文件后. 如 http://xxx.js?v=v1.0
  "environment": "develop" #开发环境 product #决定是否控制静态文件缓存
  "develop": #开发者模式配置
    "port": 3000 #运行端口
    "base": #基本配置
      "index": "index.html" #默认首页
      "cache-time": 60 * 60 * 24 * 7 #缓存时间
      "gzip": true #是否gzip资源文件
      "isWatchFile": true #是否监控文件变化刷新文件
      "showResponseTime": true #是否显示每个请求的响应时间
    "proxy": false #代理配置 #不需要代理 设为false 支持 多路径代理。将类型改成数组即可: [{path:..,options:..}]
      #{
      # "path": /^\/api/ #需要进行代理的路径。支持正则
      # "options":
      #   "target": "http://localhost:8000" #demo
      #}
    "error": #错误页面配置
      "403": ''
    "log": #log配置.具体可以参考npm package log4slow的配置(http://github.com/huyinghuan/log4slow)
      "log2console": true,
      "timestamp": false,
      "levelShow": true,
      "lineInfo": false,
      "log2file": false
    "plugins":
      "autoprefixer": browsers: ["last 2 versions"]#自动加css前缀


  ###项目打包时会读取该选项的配置###
  "build": require './build-config'
  "WebGlobal": require './web-global'