_http = require 'http'
_router = require './router'
_middleware = require './middleware'

port = SLOW.port
server = _http.createServer(
  (req, res)->
    _middleware.add _router
    _middleware.next(req, res)
)

server.listen port
console.log "Server running at http://127.0.0.1:#{port}/"