URLExtra = sload 'utils/url-extra'
_utils_file = sload 'utils/file'
responseDir = sload('middleware/end/response-directory')

module.exports =  (req, resp, next)->
  url = new URLExtra req
  pathName = url.getPathName()
  req.client = {}
  #是否访问默认路径 /
  req.client.pathName = if pathName is '/' then SLOW.base.index else pathName

  #这里是由于mime库判断文件 /css 符合text/css 导致的
  #响应文件夹
  filePath = _utils_file.getFilePath req.client.pathName
  if _utils_file.isDir(filePath)
    responseDir(req, resp, next)
  else
    next()