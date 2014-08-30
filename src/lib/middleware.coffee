_fs = require 'fs'
_path = require 'path'

_router = require './router'
_firstest = require './middleware/special/firstest'

wares = []

addMiddleware = (ware)->
  wares.push ware

#扫描中间件
scanMiddleware = ->
  #获取中间件目录
  dir = _path.join __dirname, 'middleware'
  files = _fs.readdirSync dir
  for file in files
    filepath = _path.join(dir, file)
    #加入到中间件队列
    addMiddleware require filepath if _fs.statSync(filepath).isFile()
  0

#最先执行的中间件
scanHeadMiddleware = ->
  addMiddleware _router
  addMiddleware _firstest

#初始化中间件队列
initMiddlewareStack = ()->
  scanMiddleware()
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


