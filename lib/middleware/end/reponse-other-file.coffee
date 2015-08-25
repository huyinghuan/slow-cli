###
  响应静态资源请求
###

_utils_file = sload 'utils/file'
_utils_handlebar = sload 'utils/handlebar'

module.exports = (req, resp, next)->
  pathName = req.client.pathName
  #其他资源
  filePath = _utils_file.getFilePath pathName
  #判断文件是否存在
  return next() if not _utils_file.isFile(filePath)
  resp.doCache()
  #文件存在直接输出文件
  resp.sendFile filePath