_path = require 'path'
_less = require 'less'
_fse = require 'fs-extra'
_fs = require 'fs'
_async = require 'async'
_utils_file = sload 'utils/file'
_doBuildCommon = sload('bootstrap/build/index').doBuildCommon
$cwd = process.cwd()
$buildTarget = SLOW._config_.build.target

getCssParserOptions = ->
  dirs = SLOW._config_.common?.lessImportDiretory or []
  dirs = [].concat(dirs)
  queue = []
  queue.push _path.join(process.cwd(), dir) for dir in dirs

  return paths: queue

cssParserOption = getCssParserOptions()

#编译less
module.exports = (filename, buildFilename, next)->
  factory = (filename)->
    console.log "less parse #{filename}"
    buildTargetFilename = _utils_file.replaceFileExt filename, "css"
    buildTargetFilePath = _path.join $buildTarget, buildTargetFilename
    _fse.ensureFileSync buildTargetFilePath

    queue = []

    queue.push (cb)->
      _fs.readFile _path.join($cwd, filename), encoding: "utf8", (err, content)->
        cb(err, content)

    queue.push (content, cb)->
      _less.render(content, cssParserOption).then((output)->
        cb(null, output.css)
      )

    queue.push (css, cb)->
      _fse.outputFile buildTargetFilePath, css, (err)->
        cb(err)

    _async.waterfall(queue, (err)->
      console.error err if err
      next filename, buildTargetFilePath if not err
    )

  _doBuildCommon filename, buildFilename, 'lessCompile', next, factory