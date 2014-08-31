###
  文件操作相关
###
_path = require 'path'
File = module.exports = {}

#获取资源文件的绝对路径
File.getFilePath = (relativePath)->
  return _path.join SLOW.cwd, relativePath