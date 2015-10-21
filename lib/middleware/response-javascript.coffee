###
  响应.js请求
###
_mime = require 'mime'
_utils_file = sload 'utils/file'
_fs = require 'fs'
_async = require 'async'

_coffeeCompile = sload 'compile/coffee'
_cjsxCompile = sload 'compile/cjsx'
_jsxCompile = sload 'compile/react-jsx'

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
  compile = null
  fileRealPath = ""
  if _fs.existsSync(fileRealPath = cjsxFilePath)
    compile = _cjsxCompile
  else if _fs.existsSync(fileRealPath = coffeeFilePath)
    compile = _coffeeCompile
  else if _fs.existsSync(fileRealPath = jsxFilePath)
    compile = _jsxCompile
  else #如果 coffee和cjsx 也不存在
    return next()

  compile(fileRealPath, (err, content)->
    return resp.throwsServerError() if err
    resp.sendContent content, mime
  )