wares = []
#扫描中间件
scanMiddleware = ->


scanMiddleware()

getMiddleware = ->
  wares

addMiddleware = (ware)->
  wares.push ware

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


