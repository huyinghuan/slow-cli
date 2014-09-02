###
  响应.css请求
###
_mime = require 'mime'
_utils_file = require '../utils/file'
_fs = require 'fs'
module.exports = (req, resp, next)->
  pathName = req.client.pathName
  #是否为css请求
  return next() if _mime.lookup(pathName) isnt 'text/css'
  filePath = _utils_file.getFilePath pathName
  #判断文件是否存在
  flag = _fs.existsSync filePath
  #文件存在直接输出文件
  return resp.sendFile filePath if flag

  #如果文件不存在，替换成coffee继续尝试
  pathArray = filePath.split('.')
  pathArray[pathArray.length - 1] = '.coffee'
  filePath = pathArray.join('.')
  console.log filePath
  next()