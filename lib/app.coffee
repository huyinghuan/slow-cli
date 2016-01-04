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
#去除文件监控,加快安装速度
#initWatchFile = ()->
#  _io = require('socket.io')(server)
#  _utils_file.watch (filePath)->
#    filePath = filePath.replace(SLOW.cwd, '')
#    filePath = filePath.replace(/\.hbs$/, '.html')
#    filePath = filePath.replace(/\.less/, '.css')
#    filePath = filePath.replace(/\.coffee$/, '.js')
#    filePath = '/' if filePath is "/#{SLOW.base.index}"
#    _io.sockets.emit 'file-change', filePath
#
##生产环境中不建设文件变化
#if not SLOW.isProduct()
#  initWatchFile()


server.listen port

console.log "slow-cli version is #{SLOW.version}"
console.log "Server enviroment is '#{environment}'"
console.log "Server running at http://127.0.0.1:#{port}/"
