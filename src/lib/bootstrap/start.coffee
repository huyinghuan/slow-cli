_pathJudge = require 'path-judge'

module.exports = (program, next)->
  return next() if not program.start

  #配置文件路径
  configureFilePath = false

  #运行时目录
  runtimeDirectory = false

  #是否指定运行时目录
  if program.workspace
    runtimeDirectory = _pathJudge.getFilePathBaseOnProcess(program.workspace)

  #如果指定运行时配置文件
  if program.configure
    configureFilePath = _pathJudge.getFilePathBaseOnProcess(program.configure)

  #更新全局变量
  sload('global')(program, {
    runtimeDirectory: runtimeDirectory
    runtimeConfigureFilePath: configureFilePath
  })

  sload('app')