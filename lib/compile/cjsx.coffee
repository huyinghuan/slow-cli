_fs = require 'fs'
_async = require 'async'
_coffee = require 'coffee-script'
_cjsxTransform = require 'coffee-react-transform'

module.exports = (realFilePath, cb)->
  queue = []
  queue.push (next)->
    _fs.readFile realFilePath, encoding: "utf8", (err, content)->
      next(err, content)

  queue.push (content, cb)->
    try
      content = _cjsxTransform(content)
      source = _coffee.compile content
      cb(null, source)
    catch e
      cb(e)

  _async.waterfall(queue, (err, content)->
    console.error("CJSX parse error: #{realFilePath} \n".red, err) if err
    cb(err, content)
  )