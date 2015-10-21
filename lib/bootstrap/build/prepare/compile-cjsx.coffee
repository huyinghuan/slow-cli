#编译coffee
_path = require 'path'
_fse = require 'fs-extra'
_fs = require 'fs'
_async = require 'async'
_cjsxCompile = sload 'compile/cjsx'
_utils_file = sload 'utils/file'
_doBuildCommon = sload('bootstrap/build/index').doBuildCommon
$cwd = SLOW.cwd
$buildTarget = SLOW.build.target

module.exports = (filename, buildFilename, next)->
  factory = (filename)->
    console.log "coffee compile #{filename}"
    buildTargetFilename = _utils_file.replaceFileExt filename, "js"
    buildTargetFilePath = _path.join $buildTarget, buildTargetFilename
    _fse.ensureFileSync buildTargetFilePath

    queue = []
    filePath = _path.join $cwd, filename
    queue.push (cb)->
      _cjsxCompile(filePath, (err, result)-> cb(err, result))

    queue.push (content, cb)->
      _fse.outputFile buildTargetFilePath, content, (err)-> cb(err)

    _async.waterfall(queue, (err)->
      return process.exit(1) if err
      next filename, buildTargetFilePath
    )
  _doBuildCommon filename, buildFilename, 'cjsxCompile', next, factory