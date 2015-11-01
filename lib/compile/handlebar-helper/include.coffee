_path = require 'path'
_fs = require 'fs'
_Handlebars = require 'handlebars'
_HandlebarCompile = require '../index'

_contentIfNotFileInPath =
  '''
    <span style="color: red">未找到文件按 {{filePath}} (hbs or html)</span>
  '''

getContentIfNotFile = (filePath)->
  template = _Handlebars.compile(_contentIfNotFileInPath)
  template(filePath:filePath)

getRealFilePath = (filePath)->
  reg = /(\.html|\.hbs)$/
  return if reg.test filePath
  #如果不是,则补充后缀
  htmlState = _fs.statSync("#{filePath}.html")
  hbsState = _fs.stateSync("#{filePath}.hbs")
  if htmlState.isFile()
    return "#{filePath}.html"
  if hbsState.isFile()
    return "#{filePath}.hbs"
  false

getFileContent = (filePath, __global)->
  fileRealPath = getRealFilePath(filePath)
  return getContentIfNotFile(filePath) if not fileRealPath

  _HandlebarCompile.compileSync(fileRealPath, __global)


module.exports = (Handlebars, context)->
  #当前使用include文件
  theDirectoryThatBeCompiledFileIn = context.filePath

  #当前使用include文件所在文件夹, 便于相对路径应用
  dir = _path.dirname(theDirectoryThatBeCompiledFileIn)
  #全局变量
  __global = context.global

  helpName = 'include'

  Handlebars.unregisterHelper helpName

  #html 文件引用
  #文件名字中不能包含空格
  #相对路径，支持一次引用多个 ＇,＇分割开来. 如  'a.html, b.html, c.html'
  Handlebars.registerHelper helpName, (includeFilePath)->
    filePathArray = includeFilePath.replace(/\s/g, "").split(',')
    queue = []
    for itemPath in filePathArray
      #当前include文件可能的文件路径
      queue.push(getFileContent(_path.join(dir, itemPath)), __global)

    html = queue.join('\n')
    return new _Handlebars.SafeString html
