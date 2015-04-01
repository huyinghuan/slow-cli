###
  响应.js请求
###
_mime = require 'mime'
_utils_file = sload 'utils/file'
_fs = require 'fs'
_async = require 'async'
_coffee = require 'coffee-script'
_cjsxTransform = require 'coffee-react-transform'

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

  #如果文件不存在，替换成 cjsx 继续尝试
  cjsxFilePath = filePath.replace(/(\.js)$/, '.cjsx')
  #如果文件不存在，替换成coffee继续尝试
  coffeeFilePath = filePath.replace(/(\.js)$/, '.coffee')

  if _fs.existsSync cjsxFilePath
    isCjsxFile = true
    filePath = cjsxFilePath
  else if _fs.existsSync coffeeFilePath
    filePath = coffeeFilePath
  else #如果 coffee和cjsx 也不存在
    return next()

  queue = []

  #读取文件
  queue.push (cb)->
    _fs.readFile filePath, encoding: 'utf8', (err, data)->
      cb err, data

  #文件编译
  queue.push (content, cb)->
    error = null
    try
      content = _cjsxTransform(content) if isCjsxFile
      compiled = _coffee.compile content
    catch e
      console.error e.toString()
      error = e
    cb error, compiled

  #请求响应
  _async.waterfall queue, (err, result)->
    return resp.throwsServerError() if err
    resp.sendContent result, mime