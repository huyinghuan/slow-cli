_path = require 'path'
_fs = require 'fs'
$identity = ".slow"
$identityFile = "config.js"
$identityFilePath = _path.join $identity, $identityFile
$defaultConfigFilePath = _path.join __dirname, "..", "sample", $identityFilePath
$defaultConfigDirectoryPath = _path.join __dirname, "..", "sample", $identity
$currentDefaultConfigFilePath = _path.join process.cwd(), $identityFilePath
$currentDefaultConfigDirectoryPath = _path.join process.cwd(), $identity
#全局变量
module.exports = (program, current, version)->
  #获取slow的配置
  configFilePath = _path.join current, $identityFilePath
  if not _fs.existsSync configFilePath
    configFilePath = $defaultConfigFilePath
  config = require configFilePath

  #开发模式 or 生产模式?
  env = program.env or config.environment
  #读取相应环境配置
  configEnv = config[env]
  global.SLOW =
    _config_: config #全局配置
    _env_: config[env] #工作环境配置
    _def_config_path_: $defaultConfigFilePath #默认配置文件路径
    port: program.port or configEnv.port #运行的端口配置
    cwd: current #slow 当前工作目录
    base: configEnv.base
    proxy: configEnv.proxy #代理配置
    env: env #当前工作环境
    log: configEnv.log #日志配置
    version: version #当前版本
    $defaultConfigFilePath: $defaultConfigFilePath #默认主配置文件路径
    $defaultConfigDirectoryPath: $defaultConfigDirectoryPath #默认配置文件存储的文件夹
    $currentDefaultConfigFilePath: $currentDefaultConfigFilePath
    $currentDefaultConfigDirectoryPath: $currentDefaultConfigDirectoryPath #运行环境中配置文件的文件夹
    isProduct: -> env is 'product'