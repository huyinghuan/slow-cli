###
  对 response 的扩展
###
_mime = require 'mime'
_fs = require 'fs'
module.exports = (req, resp, next)->
  #静态文件输出
  sendFile = (path)->
    flag = _fs.existsSync path
    resp.statusCode = 200
    #文件不存在
    if not flag
      resp.statusCode = 404
      resp.end()
      return

    type = _mime.lookup path
    resp.setHeader "Content-Type", type
    fileStream = _fs.createReadStream path
    fileStream.pipe resp
    fileStream.on 'end', ()->
      resp.end()

  #服务器内部错误
  throwsServerError = ()->
    resp.statusCode = 500
    resp.end('Server has crash！')

  #发送文本信息
  sendContent = (content, type = "text/plain")->
    resp.setHeader "Content-Type", type
    resp.statusCode = 200
    resp.write content, 'utf8'
    resp.end()

  #设置缓存
  doCache = ()->
    resp.setHeader('Cache-Control', "public, max-age=#{SLOW.base['cache-time']}")
    resp.setHeader('Expires', new Date(new Date().getTime() + SLOW.base['cache-time'] * 1000))
  resp.sendFile = sendFile
  resp.throwsServerError = throwsServerError
  resp.sendContent = sendContent
  resp.doCache = doCache
  next()