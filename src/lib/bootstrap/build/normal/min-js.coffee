###
  2015.05.04
    压缩 .js 文件的路径有错误,没有直接压缩写入到build目录
###

_path = require 'path'
_fs = require 'fs'
_fse = require 'fs-extra'
_UglifyJS = require "uglify-js"
_ = require 'lodash'
_fsUtils = sload('utils/file')

$buildTarget = SLOW.build.target

_doBuildCommon = sload('bootstrap/build/index').doBuildCommon
#以字符串形式压缩
defaultOptions = fromString: true
#获取 min配置
minOptions = SLOW._config_.build.minjs?.options
#必须继承默认值。此处压缩基于文件内容 而非文件路径
_.extend minOptions, defaultOptions

module.exports = (filename, buildFilename, next)->
  factory = (filename)->
    source = _fs.readFileSync(buildFilename, 'utf8')
    minimized = _UglifyJS.minify source, minOptions

    if not _fsUtils.isAbsolute(buildFilename)
      console.log "UglifyJS compress #{buildFilename}"
      buildFilename = _path.join $buildTarget, buildFilename

    _fse.outputFileSync buildFilename, minimized.code


    next filename, buildFilename

  _doBuildCommon filename, buildFilename, 'minjs', next, factory