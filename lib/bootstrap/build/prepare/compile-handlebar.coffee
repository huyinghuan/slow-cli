_path = require 'path'
_fse = require 'fs-extra'
_utils_file = sload 'utils/file'
_HandlebarCompile = sload 'compile/handlebar'
_doBuildCommon = sload('bootstrap/build/index').doBuildCommon
$cwd = SLOW.cwd
$buildTarget = SLOW.build.target

#编译hbs
module.exports = (filename, buildFilename, next)->
  factory = (filename)->
    console.log "Handlebar parse #{filename}"
    buildTargetFilename = _utils_file.replaceFileExt filename, "html"
    buildTargetFilePath = _path.join $buildTarget, buildTargetFilename
    #自动生成文件目录
    _fse.ensureFileSync buildTargetFilePath

    queue = []
    filePath = _path.join $cwd, filename
    queue.push (cb)->
      _HandlebarCompile(filePath, (err, result)-> cb(err, result))

    queue.push (content, cb)->
      _fse.outputFile buildTargetFilePath, content, (err)-> cb(err)

    _async.waterfall(queue, (err)->
      return process.exit(1) if err
      next filename, buildTargetFilePath
    )

  _doBuildCommon filename, buildFilename, 'hbsCompile', next, factory