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

  resp.sendFile = sendFile
  next()