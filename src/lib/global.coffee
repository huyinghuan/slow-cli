_path = require 'path'
_pathJudge = require 'path-judge'
_fs = require 'fs'
#slow-cli的相关文件夹文件名的设置
pkg =  _path.resolve __dirname, '../package.json'
version = require(pkg).version

$identity = ".slow"
$identityFile = "config.js"

$identityFilePath = _path.join $identity, $identityFile

#默认配置的位置
$defaultConfigFilePath = _path.resolve __dirname, "../sample", $identityFilePath
$defaultConfigDirectoryPath = _path.resolve __dirname, "../sample", $identity
#默认demo的文件夹位置
$defaultDemoDirectory = _path.resolve __dirname, "../sample"
#默认运行时文件夹 为 进程目录
$defaultRuntimeDirectory = process.cwd()
#默认运行时的配置文件位置
$defaultRuntimeConfigureFilePath = false


#初始化运行时需要的全局变量
initRuntimeGlobalConfig = (program, setting)->
  #读取工作目录
  runtimeDirectory = setting.runtimeDirectory
  #获取实际运行时文件配置路径
  runtimeConfigureFilePath = setting.runtimeConfigureFilePath

  #如果配置文件不存在，那么则表示运行的是 demo
  if not _fs.existsSync runtimeConfigureFilePath
    #获取demo的文件夹
    runtimeDirectory = $defaultDemoDirectory
    #获取demo的配置文件
    runtimeConfigureFilePath = $defaultConfigFilePath

    console.log "you have not init slow, " +
      "please run 'slow init' in the project directory \n" +
      "or set the project directory by 'slow -r path/to/project' \n" +
      "more information run 'slow -h'".yellow

  console.log "slow run in #{runtimeDirectory}".blue

  config = require runtimeConfigureFilePath

  #开发模式 or 生产模式?
  env = program.env or config.environment
  #读取相应环境配置
  configEnv = config[env]

  global.SLOW =
    _config_: config #全局配置
    #下面是slow start需要的相关配置
    _env_: config[env] #工作环境配置
    port: program.port or configEnv.port #运行的端口配置
    cwd: runtimeDirectory #slow 当前工作目录
    base: configEnv.base
    proxy: configEnv.proxy #代理配置
    env: env #当前工作环境
    log: configEnv.log #日志配置
    version: version #当前版本
    isProduct: -> env is 'product'

#初始化 初始化项目需要的全局变量
initInitGlobalConfig = (program, setting)->
  #读取工作目录
  runtimeDirectory = setting.runtimeDirectory
  global.SLOW =
    #初始化时，配置文件应该存放的文件路径
    $currentDefaultConfigFilePath: _path.join runtimeDirectory, $identityFilePath
    $currentDefaultConfigDirectoryPath: _path.join runtimeDirectory, $identity
    $defaultConfigDirectoryPath: $defaultConfigDirectoryPath #默认配置文件存储的文件夹

#全局变量
module.exports = (program)->

  #运行时配置文件路径
  runtimeConfigureFilePath = false

  #运行时目录
  runtimeDirectory = false

  #是否指定运行时目录
  if program.workspace
    runtimeDirectory = _pathJudge.getFilePathBaseOnProcess(program.workspace)

  #如果指定运行时配置文件
  if program.configure
    runtimeConfigureFilePath = _pathJudge.getFilePathBaseOnProcess(program.configure)

  #读取工作目录
  runtimeDirectory = runtimeDirectory or $defaultRuntimeDirectory

  #设置默认运行时配置文件路径
  $defaultRuntimeConfigureFilePath = _path.join runtimeDirectory, $identityFilePath

  #获取实际运行时文件配置路径
  runtimeConfigureFilePath = runtimeConfigureFilePath or $defaultRuntimeConfigureFilePath

  setting =
    runtimeDirectory: runtimeDirectory
    runtimeConfigureFilePath: runtimeConfigureFilePath

  if program.start
    initRuntimeGlobalConfig(program, setting)
  else if program.init
    initInitGlobalConfig(program, setting)
  else if program.build
    initBuildGlobalConfig(program, setting)