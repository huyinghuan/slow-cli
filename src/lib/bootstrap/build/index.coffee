_fs = require 'fs'
_fse = require 'fs-extra'
_path = require 'path'
_ = require 'lodash'
_sload = require 'sload'

$config = SLOW.build
$buildTarget = SLOW.build?.target

getModuleList = ->
  queue = []
  queue = queue.concat _sload.scan _path.join(__dirname, 'prepare')
  queue = queue.concat _sload.scan _path.join(__dirname, 'normal')
  return queue

#转成标准配置格式
prepareConfig = (config)->
  if _.isRegExp(config) or _.isArray(config)
    config =
      include: [].concat(config)
      ignore: []
  rules = [].concat(config.include or [])
  ignoreRules = [].concat(config.ignore or [])
  config.include = rules
  config.ignore = ignoreRules
  return config

#忽略全局配置
doBuildIgnore = (filename, buildFilename, next)->
  return next filename, buildFilename if not $config.ignore
  rules = prepareConfig($config.ignore).include
  return for rule in rules when rule.test filename
  return if filename.indexOf($buildTarget) is 0
  return if filename.indexOf("/#{$buildTarget}") is 0
  next filename, buildFilename

#copy
doBuildCopy = (filename, buildFilename, next)->
  #原始文件名和处理后的文件名一致， 则没有经过处理
  return if buildFilename isnt filename
  console.log "do copy #{filename}"
  buildTargetFilePath =  _path.join $buildTarget, filename
  _fse.copySync filename, buildTargetFilePath

#通用的文件处理
exports.doBuildCommon = (filename, buildFilename, buildConfig, next, factory)->
  #配置文件不存在
  return next filename, buildFilename if not $config[buildConfig]
  buildConfig = prepareConfig $config[buildConfig]
  rules = buildConfig.include
  ignoreRules = buildConfig.ignore
  #是否匹配该处理函数
  isMatchFile = false
  for rule in rules
    continue if not _.isRegExp rule
    if rule.test filename
      isMatchFile = true
      break

  return next filename, buildFilename if not isMatchFile

  for ignoreRule in ignoreRules
    continue if not _.isRegExp ignoreRule
    return next filename, buildFilename if ignoreRule.test filename
  factory filename

exports.getPipeList = ->
  list = [doBuildIgnore]
  list = list.concat getModuleList()
  list = list.concat doBuildCopy
  return list
