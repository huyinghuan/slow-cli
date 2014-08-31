URLExtra = require './utils/url-extra'

module.exports =  (req, resp, next)->
  url = new URLExtra req
  pathName = url.getPathName()
  req.client = {}
  #是否访问默认路径 /
  req.client.pathName = if pathName is '/' then SLOW.base.index else pathName

  next()