###
  响应.js请求
###
_mime = require 'mime'
_utils_file = sload 'utils/file'
_fs = require 'fs'
_async = require 'async'
_coffee = require 'coffee-script'
_cjsxTransform = require 'coffee-react-transform'
_react_tools = require 'react-tools'

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
  #如果文件不存在， 替换成jsx 继续尝试
  jsxFilePath = filePath.replace(/(\.js)$/, '.jsx')

  if _fs.existsSync cjsxFilePath
    isCjsxFile = true
    isCoffeeFile = true
    filePath = cjsxFilePath
  else if _fs.existsSync coffeeFilePath
    filePath = coffeeFilePath
    isCoffeeFile = true
  else if _fs.existsSync jsxFilePath
    isJsxFile = true
    filePath = jsxFilePath
  else #如果 coffee和cjsx 也不存在
    return next()

  queue = []

  #读取文件
  queue.push (cb)->
    _fs.readFile filePath, encoding: 'utf8', (err, data)->
      cb err, data

  #编译 jsx
  queue.push((content, cb)->
    return cb(null, content) if not isJsxFile
    error = null
    try
      content = _react_tools.transform(content)
    catch e
      console.log e.toString()
      error = e
    cb(e, content)
  )

  #编译cjsx
  queue.push((content, cb)->
    return cb(null, content) if not isCjsxFile
    error = null
    try
      content = _cjsxTransform(content)
    catch e
      console.log error.toString()
      error = e
    cb(error, content)
  )

  #编译 coffee
  queue.push((content, cb)->
    return cb(null, content) if not isCoffeeFile
    error = null
    try
      content = _coffee.compile content
    catch e
      console.error e
      error = e
    cb error, content
  )

  #请求响应
  _async.waterfall queue, (err, result)->
    return resp.throwsServerError() if err
    resp.sendContent result, mime