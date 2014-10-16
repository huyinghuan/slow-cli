_path = require 'path'
_less = require 'less'
_fse = require 'fs-extra'
_fs = require 'fs'
_utils_file = require '../../../utils/file'
_doBuildCommon = require('./../index').doBuildCommon
$cwd = process.cwd()
$buildTarget = SLOW._config_.build.target

#编译less
module.exports = (filename, buildFilename, next)->
  factory = (filename)->
    buildTargetFilename = _utils_file.replaceFileExt filename, "css"
    buildTargetFilePath = _path.join $buildTarget, buildTargetFilename
    _fse.ensureFileSync buildTargetFilePath
    content = _fs.readFileSync _path.join($cwd, filename), encoding: "utf8"
    _less.render(content, (e, css)->
      _fse.outputFileSync buildTargetFilePath, css
      next filename, buildTargetFilePath
    )
  _doBuildCommon filename, buildFilename, 'lessCompile', next, factory