_program =  require 'commander'
_path = require 'path'
_fse = require 'fs-extra'
_fs = require 'fs'
colors = require 'colors'
Log = require 'log4slow'

identity = '.slow'

module.exports = ->
  pkg =  _path.join __dirname, '..', 'package.json'
  version = require(pkg).version

  _program.version(version)
    .option('init', 'init a slow project')
    .option('-p, --port <n>', 'slow run in port <n>')
    .option('-e, --env [value]', 'the environment that slow working,' +
      'develop or product')
    .option('build', "build project as a web project and " +
      "can don't depend on slow-cli anymore ")
    .parse(process.argv);

  current = process.cwd()
  #如果是slow 初始化
  if _program.init
    sample = _path.join __dirname, '..', 'sample', identity
    _fse.copySync sample, _path.join current, identity
    process.exit 1

  #如果是在目录下正常运行slow
  #1. 判断是否存在.slow目录
  if not _fs.existsSync _path.join(current, identity)
    console.log "you do not init slow. " +
      "please run slow init in the project directory.".yellow
    current =  _path.join(__dirname, '..', 'sample')
    console.log "slow run defalut sample in #{current}".blue

  #获取slow的配置
  config = require _path.join current, identity, "config"

  #开发模式 or 生产模式?
  env = _program.env or config.environment

  #读取相应的配置
  configEnv = config[env]

  slow = global.SLOW = {}
  #挂上端口
  slow.port = _program.port or configEnv.port
  #挂上当前运行目录
  slow.cwd = current
  #挂上基本设置
  slow.base = configEnv.base
  slow._all_ = configEnv
  slow.proxy = configEnv.proxy
  slow.env = env
  slow.log = configEnv.log
  slow.version = version
  slow.isProduct = ()->
    env is 'product'

  #构建项目
  if _program.build
    _build = require './build'
    _build current, config.build
    process.exit 1

  #启动Slow
  require '../lib/app'