###
  对 response 的扩展
###
_mime = require 'mime'
_fs = require 'fs'
_zlib = require 'zlib'
_utils_file = sload 'utils/file'

module.exports = (req, resp, next)->
  #404
  sayNoFound = ()->
    resp.statusCode = 404
    resp.end('No file found')

  #静态文件输出
  sendFile = (path)->
    flag = _fs.existsSync path
    resp.statusCode = 200
    #文件不存在
    return sayNoFound() if not flag
    mime = _mime.lookup path
    resp.setHeader "Content-Type", mime
    fileStream = _fs.createReadStream path
    if _utils_file.compressible mime
      resp.setHeader 'content-encoding', 'gzip'
      gzip = _zlib.createGzip()
      fileStream.pipe(gzip).pipe(resp)
    else
      fileStream.pipe resp

  #服务器内部错误
  throwsServerError = ()->
    resp.statusCode = 500
    resp.end('Server has crash！')

  #发送文本信息
  sendContent = (content, mime = "text/plain")->
    resp.setHeader "Content-Type", mime
    resp.statusCode = 200
    if _utils_file.compressible mime
      resp.setHeader 'content-encoding', 'gzip'
      _zlib.gzip(content, (err, result)->
        resp.write result, 'utf8'
        resp.end()
      )
    else
      resp.write content, 'utf8'
      resp.end()

  #设置缓存
  doCache = ()->
    resp.setHeader('Cache-Control', "public, max-age=#{SLOW.base['cache-time']}")
    resp.setHeader('Expires', new Date(new Date().getTime() + SLOW.base['cache-time'] * 1000))
  resp.sendFile = sendFile
  resp.sayNoFound = sayNoFound
  resp.throwsServerError = throwsServerError
  resp.sendContent = sendContent
  resp.doCache = doCache
  next()