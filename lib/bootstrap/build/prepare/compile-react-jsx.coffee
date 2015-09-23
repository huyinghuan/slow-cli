#编译 React *.jsx
_path = require 'path'
_react_tools = require 'react-tools'
_fse = require 'fs-extra'
_fs = require 'fs'

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
    content = _fs.readFileSync _path.join($cwd, filename), encoding: "utf8"

    _fse.outputFileSync buildTargetFilePath, _react_tools.transform content
    next filename, buildTargetFilePath
  _doBuildCommon filename, buildFilename, 'reactCompile', next, factory