###
  响应.js请求
###
_mime = require 'mime'
_utils_file = require '../utils/file'
_fs = require 'fs'
_async = require 'async'
_coffee = require 'coffee-script'

module.exports = (req, resp, next)->
  pathName = req.client.pathName
  mime  = _mime.lookup(pathName)
  #是否为js请求
  return next() if mime isnt 'application/javascript'
  #缓存js文件
  resp.doCache()

  filePath = _utils_file.getFilePath pathName
  #判断文件是否存在
  flag = _fs.existsSync filePath
  #文件存在直接输出文件
  return resp.sendFile filePath if flag

  #如果文件不存在，替换成coffee继续尝试
  filePath = filePath.replace(/(\.js)$/, '.coffee')

  #如果 coffee 也不存在
  next() if not _fs.existsSync filePath

  queue = []

  #读取文件
  queue.push (cb)->
    _fs.readFile filePath, encoding: 'utf8', (err, data)->
      cb err, data

  #文件编译
  queue.push (content, cb)->
    compiled = _coffee.compile content
    cb null, compiled

  #请求响应
  _async.waterfall queue, (err, result)->
    return resp.throwsServerError() if err
    resp.sendContent result, mime