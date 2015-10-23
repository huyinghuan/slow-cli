#编译 React *.jsx
_path = require 'path'
_fse = require 'fs-extra'
_async = require 'async'
_compile = sload 'compile/react-jsx'
_utils_file = sload 'utils/file'
_doBuildCommon = sload('bootstrap/build/index').doBuildCommon

$cwd = SLOW.cwd
$buildTarget = SLOW.build.target

module.exports = (filename, buildFilename, next)->
  factory = (filename)->
    console.log "react tools compile #{filename}"
    buildTargetFilename = _utils_file.replaceFileExt filename, "js"
    buildTargetFilePath = _path.join $buildTarget, buildTargetFilename
    _fse.ensureFileSync buildTargetFilePath

    queue = []
    filePath = _path.join $cwd, filename
    queue.push (cb)->
      _compile(filePath, (err, result)-> cb(err, result))

    queue.push (content, cb)->
      _fse.outputFile buildTargetFilePath, content, (err)-> cb(err)

    _async.waterfall(queue, (err)->
      return process.exit(1) if err
      next filename, buildTargetFilePath
    )
  _doBuildCommon filename, buildFilename, 'reactCompile', next, factory