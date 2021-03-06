_fs = require 'fs'
_Handlebars = require 'handlebars'
_async = require 'async'
_path = require 'path'
_util_file = require './file'
_tag = require './html-tag'
#定义前端的全局变量
WebGlobal = SLOW._config_.WebGlobal

isNeedCompile = (filePath)->
  not /(\.html)$/.test filePath


#编译文件 异步
compileFile = (filePath, cb)->

  queue = []
  #读取文件
  queue.push (next)->
    _fs.readFile filePath, encoding: 'utf8', (err, data)->
      next err, data

  #文件编译
  queue.push (content, next)->
    #文件是否需要经过handlebar编译
    return next null, content if not isNeedCompile filePath
    error = null
    try
      template = _Handlebars.compile content
      content = template(WebGlobal)
    catch e
      console.error(e)
      error = e
    next error, content

  #请求响应
  _async.waterfall queue, (err, result)->
    cb(err, result)

#编译文件 同步
compileFileSync = (filePath, context = WebGlobal)->
  html = _fs.readFileSync filePath, 'utf8'
  return html if not isNeedCompile filePath
  template = _Handlebars.compile html
  template(context)

getTemplateContent = (fileName, context = {})->
  filePath = _path.join __dirname, "handlebar-template", fileName
  html = compileFileSync filePath, context
  return html

#获取 工具模板文件
getTemplateHandlebarContent = (fileName, context = {})->
  return new _Handlebars.SafeString getTemplateContent fileName, context

##文件监视器
#_Handlebars.registerHelper 'watch_file', ()->
#  #如果是生产环境则返回空
#  return '' if SLOW.isProduct()
#  getTemplateHandlebarContent "watch-file.html"

#html 文件引用
_Handlebars.registerHelper 'include', (filePath)->
  origin_path = filePath
  filePath = _util_file.getFilePath filePath
  reg = /(\.html|\.hbs)$/
  #是否以.html 或者.hbs结尾
  if not reg.test filePath #如果不是,则补充后缀
    filePath = "#{filePath}.html"
  #文件是否存在
  flag = _fs.existsSync filePath
  if not flag
    filePath = filePath.replace(/(\.html)$/, '.hbs')
    #如果文件还是不存在
    if not _fs.existsSync filePath
      return getTemplateHandlebarContent "no-file-found.html", {filePath: origin_path}

  html = compileFileSync filePath
  return new _Handlebars.SafeString html

#js, css文件引用
_Handlebars.registerHelper 'import', (files, root)->
  root = '/' if typeof root isnt 'string'
  #根据通配符获取文件列表
  tags = _tag.generateTags _util_file.getMatchFilesQueue(files), root
  return new _Handlebars.SafeString tags

#handlebar 自定义工具
Handlebar = module.exports = {}
#编译文件 异步
Handlebar.compileFile = compileFile
#编译文件 同步
Handlebar.compileFileSync = compileFileSync

Handlebar.getTemplateContent = getTemplateContent