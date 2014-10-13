_path = require 'path'
#全局变量
module.exports = (program, current, version, identity = '.slow')->
  #获取slow的配置
  config = require _path.join current, identity, "config"
  #开发模式 or 生产模式?
  env = program.env or config.environment
  #读取相应的配置
  configEnv = config[env]
  global.SLOW =
    _config_: config
    _env_: config[env]
    _def_config_path_: _path.join(__dirname, "..", "sample", identity) #默认的文件名路径
    port: program.port or configEnv.port
    cwd: current
    base: configEnv.base
    proxy: configEnv.proxy
    env: env
    log: configEnv.log
    version: version
    identify: identity #隐藏文件夹名
    isProduct: -> env is 'product'