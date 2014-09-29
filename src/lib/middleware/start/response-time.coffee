Log = require 'log4slow'
#打印响应时间
Log.init SLOW.log

module.exports = (req, resp, next)->
  pathName = req.client.pathName
  resp.on 'finish', ()->
    startTime = req.beginTime
    spellTime = new Date().getTime() - startTime
    msg = "( #{pathName} ):#{spellTime} ms : [#{resp.statusCode}]"
    return if not SLOW.base.showResponseTime
    if resp.statusCode is 200 then Log.info msg else Log.error msg
  next()