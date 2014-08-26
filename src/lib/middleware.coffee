_fs = require 'fs'
_path = require 'path'

wares = []

addMiddleware = (ware)->
  wares.push ware

#扫描中间件
scanMiddleware = ->
  dir = _path.join __dirname, 'middleware'
  files = _fs.readdirSync dir
  addMiddleware require _path.join(dir, file) for file in files
  0

scanMiddleware()

getMiddleware = ->
  wares

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


