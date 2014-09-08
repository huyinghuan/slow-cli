module.exports =
  "environment": "develop" #开发环境 product #决定是否控制静态文件缓存
  "develop": #开发者模式配置
    "port": 3000 #运行端口
    "base": #基本配置
      "index": "index.html" #默认首页
      "cache-time": 60 * 60 * 24 * 7 #缓存时间
      "gzip": true #是否gzip资源文件
      "isWatchFile": true #是否监控文件变化刷新文件
    "proxy": #代理配置
      "path": "/api"
      "redirect": "http://localhost:8001"
    "error": #错误页面配置
      "403": ''
  "product": #成品配置
    "port": 3000 #运行端口
    "base": #基本配置
      "index": "index.html" #默认首页
      "cache-time": 60 * 60 * 24 * 7 #缓存时间
      "gzip": true
      "isWatchFile": true #在生产环境中该配置无效.也就是不会监控任何文件改变
    "proxy": #代理配置
      "path": "/api"
      "redirect": "http://localhost:8001"
    "error": #错误页面配置
      "403": ''