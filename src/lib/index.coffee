_program =  require 'commander'
_path = require 'path'
_fs = require 'fs-extra'

identity = '.slow'

module.exports = ->
  version =  _path.join __dirname, '..', 'package.json'
  _program.version(version)
          .option('init', 'init a slow project')
          .option('-p, --port <n>', 'slow run in port <n>')
          .parse(process.argv);

  current = process.cwd()
  #初始化
  if _program.init
    sample = _path.join __dirname, '..', 'sample'
    _fs.copySync sample, _path.join current, identity
    process.exit 1

  config = require _path.join current, identity, "config.json"

  global.SLOW = {}

  global.SLOW.port = _program.port or config.port

  #启动Slow
  require '../lib/app'







  console.log 2
