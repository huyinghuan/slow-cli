###
  响应静态资源请求
###
Log = require 'log4slow'
_mime = require 'mime'
_utils_file = require '../../utils/file'
_fs = require 'fs'
module.exports = (req, resp, next)->
  pathName = req.client.pathName
  Log.debug "other resource", _mime.lookup(pathName)
  #其他资源
  filePath = _utils_file.getFilePath pathName
  #判断文件是否存在
  flag = _fs.existsSync filePath
  #文件存在直接输出文件
  return resp.sendFile filePath if flag
  next()