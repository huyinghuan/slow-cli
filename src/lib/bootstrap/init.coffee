#slow初始化
_fse = require 'fs-extra'

module.exports = (program, next)->
  return next() if not program.init
  sload('global')(program)

  _fse.ensureFileSync SLOW.$currentDefaultConfigFilePath
  #copy配置文件
  _fse.copySync SLOW.$defaultConfigDirectoryPath, SLOW.$currentDefaultConfigDirectoryPath
  process.exit 1