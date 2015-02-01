_path = require 'path'
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

#默认运行时文件夹
$defaultRuntimeDirectory = process.cwd()

#默认运行时的配置文件位置
$defaultRuntimeConfigureFilePath = false

#$currentDefaultConfigFilePath = _path.join process.cwd(), $identityFilePath
#$currentDefaultConfigDirectoryPath = _path.join process.cwd(), $identity #用于拷贝配置文件



#全局变量
module.exports = (program, setting)->

  #读取工作目录
  runtimeDirectory = setting.runtimeDirectory or $defaultRuntimeDirectory

  #设置默认运行时配置文件路径
  $defaultRuntimeConfigureFilePath = _path.join runtimeDirectory, $identityFilePath

  #获取实际运行时文件配置路径
  runtimeConfigureFilePath = setting.runtimeConfigureFilePath or $defaultRuntimeConfigureFilePath

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
    #下面是slow init需要的配置
    $defaultConfigFilePath: $defaultConfigFilePath #默认主配置文件路径
    $defaultConfigDirectoryPath: $defaultConfigDirectoryPath #默认配置文件存储的文件夹
   # $currentDefaultConfigFilePath: $currentDefaultConfigFilePath
  #  $currentDefaultConfigDirectoryPath: $currentDefaultConfigDirectoryPath #运行环境中配置文件的文件夹
    isProduct: -> env is 'product'