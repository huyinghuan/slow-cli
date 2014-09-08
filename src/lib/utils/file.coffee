###
  文件操作相关
###
_path = require 'path'
_mime = require 'mime'
_isGzip = SLOW.base.gzip

File = module.exports = {}

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