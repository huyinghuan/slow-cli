###
  响应.html .hbs请求
###
_mime = require 'mime'
_utils_file = sload 'utils/file'
_fs = require 'fs'
_utils_handlebar = sload 'utils/handlebar'

module.exports = (req, resp, next)->
  pathName = req.client.pathName
  mime  = _mime.lookup(pathName)
  #是否为html请求
  return next() if mime isnt 'text/html'
  filePath = _utils_file.getFilePath pathName
  #判断文件是否存在
  flag = _fs.existsSync filePath

  if not flag
    #如果文件不存在，替换成模板元素继续尝试
    filePath = filePath.replace(/(\.html)$/, '.hbs')
    #如果hbs也不存在
    return next() if not _fs.existsSync filePath

  _utils_handlebar.compileFile filePath, (err, content)->
    return resp.throwsServerError() if err
    resp.sendContent content, mime