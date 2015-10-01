_path = require 'path'
_less = require 'less'
_fse = require 'fs-extra'
_fs = require 'fs'
_async = require 'async'
_ = require 'lodash'
LessPluginAutoPrefix = require 'less-plugin-autoprefix'

_utils_file = sload 'utils/file'
_doBuildCommon = sload('bootstrap/build/index').doBuildCommon
$cwd = SLOW.cwd
$buildTarget = SLOW.build.target

isAutoPrefixer = SLOW.plugins.autoprefixer #是否增加浏览器兼容
autoprefixPlugin = false
if isAutoPrefixer
  options = if _.isPlainObject(isAutoPrefixer) then isAutoPrefixer else {}
  autoprefixPlugin = new LessPluginAutoPrefix(options)

#编译less
module.exports = (filename, buildFilename, next)->
  factory = (filename)->
    console.log "less parse #{filename}"
    buildTargetFilename = _utils_file.replaceFileExt filename, "css"
    buildTargetFilePath = _path.join $buildTarget, buildTargetFilename
    _fse.ensureFileSync buildTargetFilePath

    #获取import路径
    cssParserOption = paths: [_path.resolve($cwd, _path.dirname(filename))]
    #增加autoprefix插件
    cssParserOption.plugins = [autoprefixPlugin] if autoprefixPlugin

    queue = []

    queue.push (cb)->
      _fs.readFile _path.join($cwd, filename), encoding: "utf8", (err, content)->
        cb(err, content)

    queue.push (content, cb)->
      _less.render(content, cssParserOption).then((output)->
        cb(null, output.css)
      ).catch((e)->
        cb(e)
      )

    queue.push (css, cb)->
      _fse.outputFile buildTargetFilePath, css, (err)->
        cb(err)

    _async.waterfall(queue, (err)->
      return console.error("Less parse error: #{filename} \n".red, err) if err
      next filename, buildTargetFilePath
    )

  _doBuildCommon filename, buildFilename, 'lessCompile', next, factory