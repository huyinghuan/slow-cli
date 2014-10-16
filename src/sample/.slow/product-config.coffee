module.exports =
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