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
    switch resp.statusCode
      when 200, 304 then Log.info msg
      when 401, 403, 404, 500
        Log.error msg
      else Log.info msg
  next()