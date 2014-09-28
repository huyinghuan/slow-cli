_fse = require 'fs-extra'

#项目打包
module.exports = (current, config)->
  buildPath = _path.join current, config.build.target
  _fse.mkdirpSync buildPath