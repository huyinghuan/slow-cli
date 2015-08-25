#响应文件夹
_utils_file = sload 'utils/file'
_utils_handlebar = sload 'utils/handlebar'
_fs = require 'fs'
_path = require 'path'
module.exports = (req, resp, next)->
  pathName = req.client.pathName
  #其他资源
  filePath = _utils_file.getFilePath pathName
  return next() if not _utils_file.isDir(filePath)
  fileList = _fs.readdirSync filePath
  queue = []
  for file in fileList
    type = if _utils_file.isFile(_path.join(filePath, file)) then 'file' else 'dir'
    queue.push name: file, type: type, url: _path.join(pathName, file)

  html = _utils_handlebar.getTemplateContent("director-filelist.hbs", {filelist: queue})
  resp.sendContent(html, "text/html")