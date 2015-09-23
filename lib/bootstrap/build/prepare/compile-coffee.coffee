#编译coffee
_path = require 'path'
_coffee = require 'coffee-script'
_fse = require 'fs-extra'
_fs = require 'fs'
_cjsxTransform = require 'coffee-react-transform'

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
    content = _fs.readFileSync _path.join($cwd, filename), encoding: "utf8"

    #判断是否为cjsx文件
    content = _cjsxTransform(content) if /.+(\.cjsx)$/.test(filename)

    _fse.outputFileSync buildTargetFilePath, _coffee.compile content
    next filename, buildTargetFilePath
  _doBuildCommon filename, buildFilename, 'coffeeCompile', next, factory