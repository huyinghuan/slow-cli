_fs = require 'fs'
_pathJudge = require 'path-judge'
_path = require 'path'
_utils_file = sload 'utils/file'
_build = require './build/index'
#当前运行目录
$current = false
#退出进程
end = -> process.exit 1

initVariable = ->
  $current = SLOW.cwd

#3 文件处理
buildFile = (file)->
  path = file.replace "#{$current}/", ""
  list = _build.getPipeList()
  next = (filename, buildFilename)->
    return if not list.length
    build = list.shift()
    build filename, buildFilename, next
  next path, path

module.exports = (program, next)->
  return next() if not program.build
  initVariable()
  console.log 'Building...'.blue
  allFiles = _utils_file.getAllFile $current
  console.log allFiles
  end()
  buildFile filename for filename in allFiles
  console.log 'Build complete!'.green