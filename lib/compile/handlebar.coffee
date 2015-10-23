_async = require 'async'
_fs = require 'fs'

module.exports = (realFilePath, cb)->
  queue = []
  queue.push (next)->
    _fs.readFile realFilePath, encoding: "utf8", (err, content)->
      next(err, content)

  queue.push (content, cb)->


  _async.waterfall(queue, (err, content)->
    console.error("Handlebars parse error: #{realFilePath} \n".red, err) if err
    cb(err, content)
  )