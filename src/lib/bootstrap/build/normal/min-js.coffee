_path = require 'path'
_fs = require 'fs'
_fse = require 'fs-extra'
_UglifyJS = require "uglify-js"
_ = require 'lodash'
_doBuildCommon = require('./../index').doBuildCommon
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
    _fse.outputFileSync buildFilename, minimized.code
    next filename, buildFilename

  _doBuildCommon filename, buildFilename, 'minjs', next, factory