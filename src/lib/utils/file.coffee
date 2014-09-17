###
  文件操作相关
###
_path = require 'path'
_mime = require 'mime'
_chokidar = require 'chokidar'
_glob = require 'glob'

_util_string = require './String'

_isGzip = SLOW.base.gzip
_isWatch = SLOW.base.isWatchFile

File = module.exports = {}

#可压缩文件类型 队列
compressibleQueue = []

#可压缩的文件
initCompressibleQueue = ()->
  queue = ['.js', '.css']
  compressibleQueue.push _mime.lookup ext for ext in queue

initCompressibleQueue()

#获取资源文件的绝对路径
File.getFilePath = (relativePath)->
  return _path.join SLOW.cwd, relativePath

#判断文件是否可压缩
File.compressible = (fileMime)->
  return false if not _isGzip
  return true for mime in compressibleQueue when fileMime is mime
  return false

File.watch  = (cb)->
  return if not _isWatch
  console.log 'watch file is working...'
  #watch file
  options =
    ignored: /[\/\\]\./
    persistent: true
  cwd = SLOW.cwd
  watcher = _chokidar.watch(cwd, options)

  cb((socket)->
    watcher.on('change', (path)->
      socket.emit('file-change')
    )
  )

#获取通配符匹配的文件名
File.getMatchFilesQueue = (wildcard)->
  filePathQueue = wildcard.split ','
  queue = []
  queue = queue.concat _glob.sync filePath, cwd: SLOW.cwd for filePath in filePathQueue when not _util_string.isEmpty filePath
  return queue