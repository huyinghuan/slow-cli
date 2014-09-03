Log = require 'log4slow'
#打印响应时间
module.exports = (req, resp, next)->
  pathName = req.client.pathName
  resp.on 'finish', ()->
    startTime = req.beginTime
    spellTime = new Date().getTime() - startTime
    Log.info "path ( #{pathName} ):#{spellTime} ms : [#{resp.statusCode}]"
  next()