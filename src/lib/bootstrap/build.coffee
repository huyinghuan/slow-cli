_fs = require 'fs'
_utils_file = sload 'utils/file'
_build = require './build/index'
#当前运行目录
$current = SLOW.cwd
#退出进程
end = -> process.exit 1

#1 检查是否为slow 项目, 仅在自定义项目中运行build，在demo中不运行
checkLegalProject = (program)->
  return true if _fs.existsSync SLOW.$currentDefaultConfigFilePath
  console.log 'Build stop!'.yellow
  console.log "Can't build project in SLOW sample".red
  return false

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
  console.log 'Building...'.blue
  return end() if not checkLegalProject(program)
  console.log program.compile, program.output
  return

  #文件处理
  allFiles = _utils_file.getAllFile $current
  buildFile filename for filename in allFiles
  console.log 'Build complete!'.green