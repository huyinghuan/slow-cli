###
  响应.css请求
###
_mime = require 'mime'
_utils_file = require '../utils/file'
_fs = require 'fs'
_less = require 'less'
_async = require 'async'

module.exports = (req, resp, next)->
  pathName = req.client.pathName
  mime = _mime.lookup(pathName)
  #是否为css请求
  return next() if mime isnt 'text/css'
  filePath = _utils_file.getFilePath pathName
  #判断文件是否存在
  flag = _fs.existsSync filePath
  #文件存在直接输出文件
  return resp.sendFile filePath if flag

  #如果文件不存在，替换成less继续尝试
  filePath = filePath.replace(/(\.css)$/, '.less')

  #如果 coffee 也不存在
  next() if not _fs.existsSync filePath

  queue = []

  #读取文件
  queue.push (cb)->
    _fs.readFile filePath, encoding: 'utf8', (err, data)->
      cb err, data

  #文件编译
  queue.push (content, cb)->
    _less.render(content, (e, css)->
      cb e, css
    )

  #请求响应
  _async.waterfall queue, (err, result)->
    return resp.throwsServerError() if err
    resp.sendContent result, mime