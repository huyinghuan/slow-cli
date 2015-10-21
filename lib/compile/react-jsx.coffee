_fs = require 'fs'
_async = require 'async'
_react_tools = require 'react-tools'

module.exports = (realFilePath, cb)->
  queue = []
  queue.push (next)->
    _fs.readFile realFilePath, encoding: "utf8", (err, content)->
      next(err, content)

  queue.push (content, cb)->
    try
      source = _react_tools.transform content
      cb(null, source)
    catch e
      cb(e)

  _async.waterfall(queue, (err, content)->
    console.error("ReactTools parse jsx error: #{realFilePath} \n".red, err) if err
    cb(err, content)
  )