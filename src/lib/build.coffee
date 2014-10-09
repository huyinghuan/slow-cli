_fse = require 'fs-extra'
_utils_file = require './utils/file'
buildConfig = {}
buildCopy = (filePath, next)->
buildMin = (filePath, next)->
buildCompileHbs = (filePath, next)->
buildCompileCoffee = (filePath, next)->

build = (filePath)->


#项目打包
module.exports = (current, config)->
  buildConfig = config
  #创建打包目录
  buildPath = _path.join current, buildConfig.target
  _fse.mkdirpSync buildPath

  #获取所有项目文件
  allFils = _utils_file.getAllFile current
  for filePath in allFils
    build filePath