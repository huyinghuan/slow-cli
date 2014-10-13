_path = require 'path'
_fse = require 'fs-extra'
_fs = require 'fs'
_colors = require 'colors'

$current = SLOW.cwd
$identify = SLOW.identify
$defConfigPath = SLOW._def_config_path_

copyConfig = ()->
  configFilename = "config.js"
  configDirecotory = _path.join $current, $identify
  configPath = _path.join configDirecotory, configFilename
  if _fs.existsSync(configPath)
    #备份
    _fse.copySync configPath,
      _path.join(configDirecotory, "#{configFilename}.bak")
    _fse.copySync _path.join($defConfigPath, configFilename),
      _path.join(configDirecotory, configFilename)
  else
    console.log(
      "There isn't slow project.Please run `slow init` at first.".yellow
    )


module.exports = (program, next)->
  console.log 1
  #return next() if !program.update
  #copyConfig()
  process.exit 1