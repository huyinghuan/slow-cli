_program =  require 'commander'
_path = require 'path'
_fse = require 'fs-extra'
_fs = require 'fs'
Log = require 'log4slow'
identity = '.slow'

module.exports = ->
  version =  _path.join __dirname, '..', 'package.json'
  _program.version(version)
          .option('init', 'init a slow project')
          .option('-p, --port <n>', 'slow run in port <n>')
          .parse(process.argv);

  current = process.cwd()
  #如果是slow 初始化
  if _program.init
    sample = _path.join __dirname, '..', 'sample'
    _fse.copySync sample, _path.join current
    process.exit 1


  #如果是在目录下正常运行slow
  #1. 判断是否存在.slow目录
  if not _fs.existsSync _path.join(current, identity)
    Log.warn "you do not init slow. please run slow init in the project directory."
    current =  _path.join(__dirname, '..', 'sample')
    Log.info "slow run defalut sample in #{current}"

  #获取slow的配置
  config = require _path.join current, identity, "config"
  slow = global.SLOW = {}
  #挂上端口
  slow.port = _program.port or config.port
  #挂上当前运行目录
  slow.cwd = current
  #挂上基本设置
  slow.base = config.base
  #开发模式
  slow.env = config.environment


  #启动Slow
  require '../lib/app'