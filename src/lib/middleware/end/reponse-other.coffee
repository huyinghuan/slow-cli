###
  响应静态资源请求
###

_utils_file = require '../../utils/file'
_fs = require 'fs'
module.exports = (req, resp, next)->
  pathName = req.client.pathName
  #其他资源
  filePath = _utils_file.getFilePath pathName
  #判断文件是否存在
  flag = _fs.existsSync filePath
  resp.doCache()
  #文件存在直接输出文件
  return resp.sendFile filePath if flag
  next()