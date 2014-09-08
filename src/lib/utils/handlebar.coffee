_fs = require 'fs'
_Handlebars = require 'handlebars'
_async = require 'async'
_path = require 'path'

#文件监视器
_Handlebars.registerHelper 'watch_file', ()->

  #如果是生产环境则返回空
  return '' if SLOW.isProduct()

  filePath = _path.join __dirname, "handlebar-template", "watch-file.html"
  html = _fs.readFileSync filePath, 'utf8'
  return new _Handlebars.SafeString html

#handlebar 自定义工具
Handlebar = module.exports = {}

#编译文件
Handlebar.compileFile = (filePath, cb)->
  queue = []

  #读取文件
  queue.push (cb)->
    _fs.readFile filePath, encoding: 'utf8', (err, data)->
      cb err, data

  #文件编译
  queue.push (content, cb)->
    template = _Handlebars.compile content
    cb null, template({})

  #请求响应
  _async.waterfall queue, cb


#编译内容
Handlebar.compileContent = (content, cb)->
