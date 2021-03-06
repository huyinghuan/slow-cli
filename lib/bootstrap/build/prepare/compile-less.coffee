_path = require 'path'
_less = require 'less'
_fse = require 'fs-extra'
_async = require 'async'
_lessCompile = sload 'compile/less'
_utils_file = sload 'utils/file'
_doBuildCommon = sload('bootstrap/build/index').doBuildCommon

$buildTarget = SLOW.build.target
$cwd = SLOW.cwd
#编译less
module.exports = (filename, buildFilename, next)->
  factory = (filename)->
    console.log "less parse #{filename}"
    buildTargetFilename = _utils_file.replaceFileExt filename, "css"
    buildTargetFilePath = _path.join $buildTarget, buildTargetFilename
    _fse.ensureFileSync buildTargetFilePath

    queue = []
    filePath = _path.join $cwd, filename
    queue.push (cb)->
      _lessCompile(filePath, (err, result)-> cb(err, result))

    queue.push (css, cb)->
      _fse.outputFile buildTargetFilePath, css, (err)-> cb(err)

    _async.waterfall(queue, (err)->
      return process.exit(1) if err
      next filename, buildTargetFilePath
    )

  _doBuildCommon filename, buildFilename, 'lessCompile', next, factory