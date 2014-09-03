module.exports =
  "environment": "develop" #开发环境 product #决定是否控制静态文件缓存
  "port": 3000 #运行端口
  "base": #基本配置
    "index": "index.html" #默认首页
    "cache-time": 60 * 60 * 24 * 7
  "proxy": #代理配置
    "path": "/api"
    "redirect": "http://localhost:8001"
  "error": #错误页面配置
    "403": ''