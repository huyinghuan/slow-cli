###
  响应静态资源请求
###

_utils_file = sload 'utils/file'
_fs = require 'fs'
module.exports = (req, resp, next)->
  pathName = req.client.pathName
  #其他资源
  filePath = _utils_file.getFilePath pathName
  #判断文件是否存在
  return next() if not _fs.existsSync(filePath)
  state = _fs.statSync(filePath)
  if state.isFile()
    resp.doCache()
    #文件存在直接输出文件
    return resp.sendFile filePath

  if state.isDirectory()
    #当访问的是一个文件夹时,输出该文件夹的文件目录。
    return next()

  next()