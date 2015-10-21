_path = require 'path'
_less = require 'less'
_fs = require 'fs'
_async = require 'async'
_compileAutoprefixer = require './autoprefixer'

module.exports = (realFilePath, cb)->
  #获取import路径
  cssParserOption = paths: [_path.dirname(realFilePath)]
  queue = []

  queue.push (next)->
    _fs.readFile realFilePath, encoding: "utf8", (err, content)->
      next(err, content)

  queue.push (content, next)->
    _less.render(content, cssParserOption).then((output)->
      next(null, output.css)
    ).catch((e)-> next(e))

  #add autoprefixer support
  queue.push(_compileAutoprefixer)

  _async.waterfall(queue, (err, content)->
    console.error("Less parse error: #{filename} \n".red, err) if err
    cb(err, content)
  )