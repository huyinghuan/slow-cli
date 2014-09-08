_http = require 'http'
_middleware = require './middleware'
_utils_file = require './utils/file'

port = SLOW.port
environment = SLOW.env

server = _http.createServer(
  (req, res)->
    _middleware.next(req, res)
)

#初始化文件监控
initWatchFile = ()->
  _io = require('socket.io')(server)
  _utils_file.watch (cb)->
    _io.on('connection', (socket)->
      # monitor files change
      cb socket
    )

#生产环境中不建设文件变化
if not SLOW.isProduct()
  initWatchFile()


server.listen port
console.log "Server running at http://127.0.0.1:#{port}/"
console.log "Server enviroment is '#{environment}'"