###
  响应.html .hbs请求
###
_mime = require 'mime'
_utils_file = require '../utils/file'
_fs = require 'fs'
module.exports = (req, resp, next)->
  pathName = req.client.pathName
  #是否为html请求
  return next() if _mime.lookup(pathName) isnt 'text/html'
  filePath = _utils_file.getFilePath pathName
  #判断文件是否存在
  flag = _fs.existsSync filePath
  #文件存在直接输出文件
  return resp.sendFile filePath if flag

  #如果文件不存在，替换成模板元素继续尝试
  pathArray = filePath.split('.')
  pathArray[pathArray.length - 1] = 'hbs'
  filePath = pathArray.join('.')
  console.log filePath
  next()