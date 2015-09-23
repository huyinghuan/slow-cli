#slow初始化
_fse = require 'fs-extra'

module.exports = (program, next)->
  return next() if not program.init
  #sload('global')(program)

 # _fse.ensureFileSync SLOW.$currentDefaultConfigFilePath
  #copy配置文件
  _fse.copy(SLOW.$defaultConfigDirectoryPath, SLOW.$currentDefaultConfigDirectoryPath, (err)->
    if err
      console.log "Init project failed".red
    else
      console.log "Init project success".green
    process.exit 1
  )

