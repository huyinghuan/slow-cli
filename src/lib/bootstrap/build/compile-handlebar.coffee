_path = require 'path'
_handlebar = require '../../utils/handlebar'
_fse = require 'fs-extra'
_utils_file = require '../../utils/file'
_doBuildCommon = require('./index').doBuildCommon
$cwd = process.cwd()
$buildTarget = SLOW._config_.build.target

#编译hbs
module.exports = (filename, buildFilename, next)->
  factory = (filename)->
    buildTargetFilename = _utils_file.replaceFileExt filename, "html"
    buildTargetFilePath = _path.join $buildTarget, buildTargetFilename
    #自动生成文件目录
    _fse.ensureFileSync buildTargetFilePath
    content = _handlebar.compileFileSync _path.join($cwd, filename)
    _fse.outputFileSync buildTargetFilePath, content
    next filename, buildTargetFilePath
  _doBuildCommon filename, buildFilename, 'hbsCompile', next, factory