###
  2015.05.04
    压缩 .css 文件的路径有错误,没有直接压缩写入到build目录
###

_path = require 'path'
_fs = require 'fs'
_fse = require 'fs-extra'
_CleanCSS = require 'clean-css'
_doBuildCommon = sload('bootstrap/build/index').doBuildCommon
_fsUtils = sload('utils/file')

$buildTarget = SLOW.build.target

minOptions = SLOW._config_.build.mincss?.options

module.exports = (filename, buildFilename, next)->
  factory = ()->
    source = _fs.readFileSync(buildFilename, 'utf8')
    minimized = new _CleanCSS(minOptions).minify(source)

    if not _fsUtils.isAbsolute(buildFilename)
      console.log "Clean-css compress #{buildFilename}"
      buildFilename = _path.join $buildTarget, buildFilename

    _fse.outputFileSync buildFilename, minimized
    next filename, buildFilename

  _doBuildCommon filename, buildFilename, 'mincss', next, factory