###
  响应.css请求
###
_mime = require 'mime'
_utils_file = sload 'utils/file'
_fs = require 'fs'
_ = require 'lodash'
_less = require 'less'
_async = require 'async'
_path = require 'path'

LessPluginAutoPrefix = require 'less-plugin-autoprefix'

$cwd = SLOW.cwd

isAutoPrefixer = SLOW.plugins?.autoprefixer #是否增加浏览器兼容
autoprefixPlugin = false
if isAutoPrefixer
  options = if _.isPlainObject(isAutoPrefixer) then isAutoPrefixer else {}
  autoprefixPlugin = new LessPluginAutoPrefix(options)

module.exports = (req, resp, next)->
  pathName = req.client.pathName
  mime = _mime.lookup(pathName)
  #mime bug /xx/css 应该是ostream 而不应该是text/css
  return next() if not /(\.css|\.less)$/.test(pathName)
  filePath = _utils_file.getFilePath pathName
  #判断文件是否存在
  flag = _fs.existsSync filePath
  #文件存在直接输出文件
  return resp.sendFile filePath if flag

  #如果文件不存在，替换成less继续尝试
  filePath = filePath.replace(/(\.css)$/, '.less')

  #如果 less 也不存在
  next() if not _fs.existsSync filePath

  #获取import路径
  cssParserOption = paths: [_path.resolve($cwd, _path.dirname(filePath))]
  #增加autoprefix插件
  cssParserOption.plugins = [autoprefixPlugin] if autoprefixPlugin

  queue = []

  #读取文件
  queue.push (cb)->
    _fs.readFile filePath, encoding: 'utf8', (err, data)->
      cb err, data

  #文件编译
  queue.push (content, cb)->
    _less.render(content, cssParserOption).then((output)->
      cb(null, output.css)
    ).catch((e)->
      console.error e
      cb(e)
    )

  #请求响应
  _async.waterfall queue, (err, result)->
    return resp.throwsServerError() if err
    resp.sendContent result, mime