_fs = require 'fs'
_path = require 'path'
_sload = require 'sload'
_ = require 'lodash'

_router = sload 'router'

wares = []

addMiddleware = (ware)->
  if _.isArray(ware)
    wares = wares.concat ware
  else
    wares.push ware

#扫描中间件
scanMiddleware = (middleDirector)->
  #获取中间件目录
  dir = _path.join __dirname, middleDirector
  list = _sload.scan dir
  addMiddleware(list)

#最先执行的中间件
scanHeadMiddleware = ->
  addMiddleware _router

#初始化中间件队列
initMiddlewareStack = ()->
  scanMiddleware 'middleware/error'
  scanMiddleware 'middleware/end'
  scanMiddleware 'middleware'
  scanHeadMiddleware()
  scanMiddleware 'middleware/start'

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


