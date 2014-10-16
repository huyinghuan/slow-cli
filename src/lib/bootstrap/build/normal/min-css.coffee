_path = require 'path'
_fs = require 'fs'
_fse = require 'fs-extra'
_CleanCSS = require 'clean-css'
_doBuildCommon = sload('bootstrap/build/index').doBuildCommon

minOptions = SLOW._config_.build.mincss?.options

module.exports = (filename, buildFilename, next)->
  factory = ()->
    source = _fs.readFileSync(buildFilename, 'utf8')
    minimized = new _CleanCSS(minOptions).minify(source);
    _fse.outputFileSync buildFilename, minimized
    next filename, buildFilename

  _doBuildCommon filename, buildFilename, 'mincss', next, factory