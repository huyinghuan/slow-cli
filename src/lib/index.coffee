_program =  require 'commander'
_path = require 'path'
_fse = require 'fs-extra'
_fs = require 'fs'
_build = require './build'

Log = require 'log4slow'

identity = '.slow'

module.exports = ->
  pkg =  _path.join __dirname, '..', 'package.json'
  version = require(pkg).version

  _program.version(version)
          .option('init', 'init a slow project')
          .option('-p, --port <n>', 'slow run in port <n>')
          .option('-e, --env [value]', 'the environment that slow working, develop or product')
          .option('build', "build project as a web project and can don't depend on slow-cli anymore ")
          .parse(process.argv);

  current = process.cwd()
  #如果是slow 初始化
  if _program.init
    sample = _path.join __dirname, '..', 'sample', identity
    _fse.copySync sample, _path.join current, identity
    process.exit 1

  #获取slow的配置
  config = require _path.join current, identity, "config"
  #初始化log配置
  Log.init config.log

  #构建项目
  if _program.build
    _build current, config.build
    process.exit 1

  #如果是在目录下正常运行slow
  #1. 判断是否存在.slow目录
  if not _fs.existsSync _path.join(current, identity)
    Log.warn "you do not init slow. please run slow init in the project directory."
    current =  _path.join(__dirname, '..', 'sample')
    Log.info "slow run defalut sample in #{current}"

  #开发模式 or 生产模式?
  env = _program.env or config.environment

  #读取相应的配置
  config = config[env]

  slow = global.SLOW = {}
  #挂上端口
  slow.port = _program.port or config.port
  #挂上当前运行目录
  slow.cwd = current
  #挂上基本设置
  slow.base = config.base
  slow._all_ = config
  slow.proxy = config.proxy
  slow.env = env
  slow.log = config.log
  slow.version = version
  slow.isProduct = ()->
    env is 'product'

  #启动Slow
  require '../lib/app'