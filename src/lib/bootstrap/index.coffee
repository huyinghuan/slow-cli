_sload = require 'sload'
_path = require 'path'
colors = require 'colors'

module.exports = (program)->
  straps = _sload.scan(__dirname, {ignore: (filename)->
    _path.join(__dirname, filename) is __filename
  })
  next = ()->
    step = straps.pop()
    if step
      step program, next
    else
      console.log 'Error! Invalid optional!'
  next()