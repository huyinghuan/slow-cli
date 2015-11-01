_Handlebars = require 'handlebars'
_path = require 'path'
_helperPath = _path.join(__dirname, "helper")
#扫描handlebar help 所有插件
_straps = _sload.scan(_helperPath)

#加载自定义组件
loadAllCompileHelpers = (filePath, context)->
  for helper in _straps
    break if not helper
    helper(_Handlebars, {
      filePath: filePath
      global: context
    })

HandlebarsCompile = {}
###
  @params {string} 文件绝对路径
  @params {object} 上下文环境
  @return {string}
###
HandlebarsCompile.compileSync = (filePath, context)->
  loadAllCompileHelpers(filePath, context)
  content = _fs.readFile(filePath, encoding: "utf8")
  template = _Handlebars.compile(content)
  template(content)

module.exports = HandlebarsCompile