_path = require 'path'
_fse = require 'fs-extra'
_fs = require 'fs'
_colors = require 'colors'

copyConfig = ()->
  current = SLOW.$currentDefaultConfigFilePath
  if _fs.existsSync(current)
    #备份
    _fse.copySync current, "#{current}.#{new Date().getTime()}.bak"
  #复制
  _fse.copySync SLOW.$defaultConfigFilePath, current

#检测版本
checkVersion = ()->
  #当前版本
  current = SLOW.version
  #仓库版本
  #....

module.exports = (program, next)->
  return next() if not program.update
  #copyConfig()
  process.exit 1