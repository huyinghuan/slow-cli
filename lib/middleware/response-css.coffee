###
  响应.css请求
###
_mime = require 'mime'
_utils_file = sload 'utils/file'
_fs = require 'fs'
_ = require 'lodash'
_async = require 'async'
_path = require 'path'

_sassCompile = sload 'compile/sass'
_lessCompile = sload 'compile/less'

module.exports = (req, resp, next)->
  pathName = req.client.pathName
  mime = _mime.lookup(pathName)
  #mime bug /xx/css 应该是ostream 而不应该是text/css
  return next() if not /(\.css|\.less|\.scss)$/.test(pathName)
  filePath = _utils_file.getFilePath pathName
  #判断文件是否存在
  #文件存在直接输出文件
  return resp.sendFile filePath if _fs.existsSync filePath
  #如果文件不存在，替换成less继续尝试
  compile = null
  fileRealPath = ""
  #如果 less存在
  if _fs.existsSync(fileRealPath = filePath.replace(/(\.css)$/, '.less'))
    compile = _lessCompile
    #如果 sass存在
  else if _fs.existsSync(fileRealPath = filePath.replace(/(\.css)$/, '.scss'))
    compile = _sassCompile
  else
    return next()

  compile(fileRealPath, (err, content)->
    return resp.throwsServerError() if err
    resp.sendContent content, mime
  )