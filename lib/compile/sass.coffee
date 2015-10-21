_path = require 'path'
_sass = require 'node-sass'
_fs = require 'fs'
_async = require 'async'
_compileAutoprefixer = require './autoprefixer'




module.exports = (realFilePath, cb)->
  #获取import路径
  importPaths = [_path.dirname(realFilePath)]
  queue = []

  queue.push((next)->
    _fs.readFile realFilePath, encoding: "utf8", (err, content)->
      next(err, content)
  )
  queue.push((content, next)->
    _sass.render({
      data: content
      includePaths: importPaths
    }, (err, output)->
      return next(err) if err
      next(null, output.css)
    )
  )

  #add autoprefixer support
  queue.push(_compileAutoprefixer)

  _async.waterfall(queue, (err, content)->
    console.error("Sass parse error: #{filename} \n".red, err) if err
    cb(err, content)
  )


