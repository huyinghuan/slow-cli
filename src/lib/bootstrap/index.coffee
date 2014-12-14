_sload = require 'sload'
_path = require 'path'

module.exports = (program)->
  straps = _sload.scan(__dirname, {ignore: (filename)->
    _path.join(__dirname, filename) is __filename
  })
  next = ()->
    config = straps.pop()
    config program, next if config
  next()