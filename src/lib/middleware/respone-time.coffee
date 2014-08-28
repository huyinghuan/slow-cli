Log = require 'log4slow'
URLExtra = require '../utils/url-extra'
#打印响应时间
module.exports = (req, resp, next)->
  startTime = req.beginTime
  pathName = new URLExtra(req).getPathName()
  resp.on 'finish', ()->
    spellTime = new Date().getTime() - startTime
    console.log "#{pathName}:#{spellTime} ms"
  next()