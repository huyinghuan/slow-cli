Log = require 'log4slow'
#打印响应时间
module.exports = (req, resp, next)->
  startTime = req.beginTime
  pathName = req.client.pathName
  resp.on 'finish', ()->
    spellTime = new Date().getTime() - startTime
    Log.info "path ( #{pathName} ):#{spellTime} ms"
  next()