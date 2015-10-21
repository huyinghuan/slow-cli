_path = require 'path'
_fse = require 'fs-extra'
_async = require 'async'
_utils_file = sload 'utils/file'
_sassCompile = sload 'compile/sass'

_doBuildCommon = sload('bootstrap/build/index').doBuildCommon
$cwd = SLOW.cwd
$buildTarget = SLOW.build.target


#编译less
module.exports = (filename, buildFilename, next)->
  factory = (filename)->
    console.log "Sass parse #{filename}"
    buildTargetFilename = _utils_file.replaceFileExt filename, "css"
    buildTargetFilePath = _path.join $buildTarget, buildTargetFilename
    _fse.ensureFileSync buildTargetFilePath

    queue = []
    filePath = _path.join $cwd, filename
    queue.push (cb)->
      _sassCompile(filePath, (err, result)-> cb(err, result))

    queue.push (css, cb)->
      _fse.outputFile buildTargetFilePath, css, (err)-> cb(err)

    _async.waterfall(queue, (err)->
      return process.exit(1) if err
      next filename, buildTargetFilePath
    )

  _doBuildCommon filename, buildFilename, 'sassCompile', next, factory