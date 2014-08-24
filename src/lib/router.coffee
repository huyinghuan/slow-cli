URLExtra = require './utils/url-extra'
_fileType = require './utils/file-type'

module.exports =  (req, resp, next)->
  #挂载开始时间
  req.beginTime = new Date().getTime()
  url = new URLExtra req
  pathName = url.getPathName()
  resp.end 'hello'
  #....
  #next()


