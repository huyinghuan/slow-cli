_fse = require 'fs-extra'
_fs = require 'fs'
_path = require 'path'
_coffee = require 'coffee-script'
_less = require 'less'
_utils_file = require '../utils/file'
_handlebar = require '../utils/handlebar'
#当前运行目录
current = SLOW.cwd
#当前的build配置
config = SLOW._config_.build
buildTarget = config.target
cwd = process.cwd()

#是否为正则对象
isReg = (o)-> o instanceof RegExp

#替换文件后缀
replaceFileExt = (filename, ext)->
  return "#{filename}.#{ext}" if filename.indexOf(".") is -1
  filename.substr(0, filename.lastIndexOf('.')) + ".#{ext}"

#转成标准配置格式
prepareConfig = (config)->
  if isReg config
    config =
      include: [config]
      ignore: []
  rules = [].concat(config.include or [])
  ignoreRules = [].concat(config.ignore or [])
  include: rules
  ignore: ignoreRules

#退出进程
end = -> process.exit 1

#通用的文件处理
doBuildCommon = (filename, buildFilename, buildConfig, next, factory)->
  rules = buildConfig.include
  ignoreRules = buildConfig.ignore
  for ignoreRule in ignoreRules
    return next filename, buildFilename if ignoreRule.test filename
  for rule in rules
    return factory filename if rule.test filename
  next filename, buildFilename

#忽略全局配置
doBuildIgnore = (filename, buildFilename, next)->
  rules = prepareConfig(config.ignore).include
  return for rule in rules when rule.test filename
  return if filename.indexOf(buildTarget) is 0
  return if filename.indexOf("/#{buildTarget}") is 0
  next filename, buildFilename

#编译hbs
doBuildCompileHbs = (filename, buildFilename, next)->
  factory = (filename)->
    buildTargetFilename = replaceFileExt filename, "html"
    buildTargetFilePath = _path.join buildTarget, buildTargetFilename
    #自动生成文件目录
    _fse.ensureFileSync buildTargetFilePath
    content = _handlebar.compileFileSync _path.join(cwd, filename)
    _fse.outputFileSync buildTargetFilePath, content
    next filename, buildTargetFilePath
  buildConfig = prepareConfig config.hbsCompile
  doBuildCommon filename, buildFilename, buildConfig, next, factory

#编译less
doBuildLess = (filename, buildFilename, next)->
  factory = (filename)->
    buildTargetFilename = replaceFileExt filename, "css"
    buildTargetFilePath = _path.join buildTarget, buildTargetFilename
    _fse.ensureFileSync buildTargetFilePath
    content = _fs.readFileSync _path.join(cwd, filename), encoding: "utf8"
    _less.render(content, (e, css)->
      _fse.outputFileSync buildTargetFilePath, css
      next filename, buildTargetFilePath
    )
  buildConfig = prepareConfig config.lessCompile
  doBuildCommon filename, buildFilename, buildConfig, next, factory
#copy
doBuildCopy = (filename, buildFilename, next)->
  #原始文件名和处理后的文件名一致， 则没有经过处理
  return if buildFilename isnt filename
  buildTargetFilePath =  _path.join buildTarget, filename
  _fse.copySync filename, buildTargetFilePath

getBuildList = ->
  [doBuildIgnore, doBuildCompileHbs, doBuildLess, doBuildCopy]

#1 检查是否为slow 项目, 仅在自定义项目中运行build，在demo中不运行
checkLegalProject = (program)->
  return true if program.isNormalProject
  console.log "Can't build project in SLOW sample"
  return false

#3 文件处理
buildFile = (file)->
  path = file.replace "#{current}/", ""
  list = getBuildList()
  next = (filename, buildFilename)->
    build = list.shift()
    build filename, buildFilename, next if build
  next path, path

module.exports = (program, next)->
  return next() if !program.build
  console.log 'Building...'
  return end() if not checkLegalProject(program)
  #文件处理
  allFils = _utils_file.getAllFile current
  buildFile filename for filename in allFils
  process.exit 1