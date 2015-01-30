_program =  require 'commander'
_path = require 'path'
_fs = require 'fs'
colors = require 'colors'
#初始化sload
require('sload').init __dirname

pkg =  _path.join __dirname, '..', 'package.json'
version = require(pkg).version
current = process.cwd()

_program.version(version)
  .option('init', 'init a slow project')
  .option('-p, --port <n>', 'slow run in port <n>')
  .option('-e, --env [value]', 'the environment that slow working,' +
    'develop or product')
  .option('-c, --compile [value]', 'compile source directory')
  .option('-o, --output [value]', 'output directory after compiled')
  .option('build', "build project as a web project and " +
    "can don't depend on slow-cli anymore ")
  .option('start', 'start slow server')
  .option('update', 'update')
  .parse(process.argv);

#绑定全局变量
sload('global')(_program, current, version)

#slow 可选操作
sload('bootstrap/index')(_program)

#如果是在目录下正常运行slow
#1. 判断是否存在.slow目录
if not _fs.existsSync SLOW.$currentDefaultConfigFilePath
  console.log "you don't init slow. " +
    "please run slow init in the project directory.".yellow
  current =  _path.join(__dirname, '..', 'sample')
  console.log "slow run defalut sample in #{current}".blue

#更新全局变量
sload('global')(_program, current, version)

if _program.start
  #启动Slowb
  require './app'