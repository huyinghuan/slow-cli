_fs = require 'fs'
_path = require 'path'

_router = require './router'

wares = []

addMiddleware = (ware)->
  wares.push ware

#扫描中间件
scanMiddleware = (middleDirector)->
  #获取中间件目录
  dir = _path.join __dirname, middleDirector
  files = _fs.readdirSync dir
  for file in files
    filepath = _path.join(dir, file)
    #加入到中间件队列
    addMiddleware require filepath if _fs.statSync(filepath).isFile()
  0

#最先执行的中间件
scanHeadMiddleware = ->
  addMiddleware _router

#初始化中间件队列
initMiddlewareStack = ()->
  scanMiddleware 'middleware/error'
  scanMiddleware 'middleware/end'
  scanMiddleware 'middleware'
  scanMiddleware 'middleware/start'
  scanHeadMiddleware()

initMiddlewareStack()

#获取中间件队列
getMiddleware = ->
  wares.concat []

Middleware = module.exports = {}

Middleware.add = (ware)->
  addMiddleware ware

Middleware.next = (req, resp)->
  middlewareStack = getMiddleware()
  next = ()->
    middleware = middlewareStack.pop()
    if middleware
      middleware req, resp, next
  next()


