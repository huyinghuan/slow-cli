_http = require 'http'
_middleware = sload 'middleware'
_utils_file = sload 'utils/file'
_EventEmitter = require('events').EventEmitter
port = SLOW.port
proxy = SLOW.proxy
environment = SLOW.env

server = _http.createServer(
  (req, res)->
    _middleware.next(req, res)
)

#初始化文件监控
initWatchFile = ()->
  _io = require('socket.io')(server)

  _utils_file.watch ()->
    _io.sockets.emit 'file-change'

#生产环境中不建设文件变化
if not SLOW.isProduct()
  initWatchFile()


server.listen port

console.log "slow-cli version is #{SLOW.version}"
console.log "Server enviroment is '#{environment}'"
console.log "Server running at http://127.0.0.1:#{port}/"
