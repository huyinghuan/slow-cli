_staticFile = require './static-file'
Log = require 'log4slow'
class FileType
  constructor: ->

  #获取扩展名
  getFileExtensionName: (path)->
    #获取最后一个路径
    path = path.substring(path.lastIndexOf('/') + 1)
    #获取扩名名
    index = path.lastIndexOf('.')
    #如果不包含小数点
    return '' if index is -1
    #获取扩展名
    ext = path.substring(index + 1)

  #获取扩展类型
  getFileExtensionType: (path)->
    ext = @getFileExtensionName path
    _staticFile[ext.toUpperCase()]

  #是否是静态文件
  isStaticFile: (path)->
    #扩展类型是否存在
    type = @getFileExtensionType path
    return true if type and type isnt ''
    #提示，不支持扩展名
    Log.warn "Can not support file type #{ext}"
    return false

module.exports = new FileType()