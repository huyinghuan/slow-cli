_path = require 'path'
_less = require 'less'
_fse = require 'fs-extra'
_fs = require 'fs'
_utils_file = sload 'utils/file'
_doBuildCommon = sload('bootstrap/build/index').doBuildCommon
$cwd = process.cwd()
$buildTarget = SLOW._config_.build.target

getCssParser = ->
  dirs = SLOW._config_.common?.lessImportDiretory or []
  dirs = [].concat(dirs)
  queue = []
  queue.push _path.join(process.cwd(), dir) for dir in dirs
  console.log queue
  new(_less.Parser)(paths: queue)

cssParser = getCssParser()

#编译less
module.exports = (filename, buildFilename, next)->
  factory = (filename)->
    console.log "less parse #{filename}"
    buildTargetFilename = _utils_file.replaceFileExt filename, "css"
    buildTargetFilePath = _path.join $buildTarget, buildTargetFilename
    _fse.ensureFileSync buildTargetFilePath
    content = _fs.readFileSync _path.join($cwd, filename), encoding: "utf8"
    cssParser.parse(content, (e, css)->
      _fse.outputFileSync buildTargetFilePath, css.toCSS()
      next filename, buildTargetFilePath
    )
  _doBuildCommon filename, buildFilename, 'lessCompile', next, factory