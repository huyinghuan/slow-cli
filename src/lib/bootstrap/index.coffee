_fs = require 'fs'
_path = require 'path'
getBootStraps = ->
  queue = []
  files = _fs.readdirSync __dirname
  for fileName in files
    filePath = _path.join __dirname, fileName
    continue if filePath is __filename
    queue.push require filePath if _fs.statSync(filePath).isFile()
  return queue

module.exports = (program)->
  straps = getBootStraps()
  next = ()->
    config = straps.pop()
    config program, next if config
  next()