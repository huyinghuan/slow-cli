###
  响应.html .hbs请求
###
_mime = require 'mime'
_utils_file = require '../utils/file'
_fs = require 'fs'
_Handlebars = require 'handlebars'
_async = require 'async'
module.exports = (req, resp, next)->
  pathName = req.client.pathName
  mime  = _mime.lookup(pathName)
  #是否为html请求
  return next() if mime isnt 'text/html'
  filePath = _utils_file.getFilePath pathName
  #判断文件是否存在
  flag = _fs.existsSync filePath
  #文件存在直接输出文件
  return resp.sendFile filePath if flag

  #如果文件不存在，替换成模板元素继续尝试
  pathArray = filePath.split('.')
  pathArray[pathArray.length - 1] = 'hbs'
  filePath = pathArray.join('.')
  #如果hbs也不存在
  next() if not _fs.existsSync filePath

  queue = []

  #读取文件
  queue.push (cb)->
    _fs.readFile filePath, encoding: 'utf8', (err, data)->
      cb err, data

   #文件编译
  queue.push (content, cb)->
    template = _Handlebars.compile content
    data = {name: 'hello hbs'}
    cb null, template(data)

  #请求响应
  _async.waterfall queue, (err, result)->
    return resp.throwsServerError() if err
    resp.sendContent result, mime

