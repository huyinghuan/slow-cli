_fs = require 'fs'
_fse = require 'fs-extra'
_path = require 'path'
$config = SLOW._config_.build
$buildTarget = SLOW._config_.build.target

getPipeList = ->
  queue = []
  files = _fs.readdirSync __dirname
  for fileName in files
    filePath = _path.join __dirname, fileName
    continue if filePath is __filename
    queue.push require filePath if _fs.statSync(filePath).isFile()
  return queue

#转成标准配置格式
prepareConfig = (config)->
  if config instanceof RegExp
    config =
      include: [config]
      ignore: []
  rules = [].concat(config.include or [])
  ignoreRules = [].concat(config.ignore or [])
  include: rules
  ignore: ignoreRules

#忽略全局配置
doBuildIgnore = (filename, buildFilename, next)->
  rules = prepareConfig($config.ignore).include
  return for rule in rules when rule.test filename
  return if filename.indexOf($buildTarget) is 0
  return if filename.indexOf("/#{$buildTarget}") is 0
  next filename, buildFilename

#copy
doBuildCopy = (filename, buildFilename, next)->
  #原始文件名和处理后的文件名一致， 则没有经过处理
  return if buildFilename isnt filename
  buildTargetFilePath =  _path.join $buildTarget, filename
  _fse.copySync filename, buildTargetFilePath

#通用的文件处理
exports.doBuildCommon = (filename, buildFilename, buildConfig, next, factory)->
  buildConfig = prepareConfig $config[buildConfig]
  rules = buildConfig.include
  ignoreRules = buildConfig.ignore
  for ignoreRule in ignoreRules
    return next filename, buildFilename if ignoreRule.test filename
  for rule in rules
    return factory filename if rule.test filename
  next filename, buildFilename

exports.getPipeList = ->
  list = [doBuildIgnore]
  list = list.concat getPipeList()
  list.push doBuildCopy
  return list
