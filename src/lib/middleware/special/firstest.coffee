#第一个中间件
module.exports = (req, resp, next)->
  #挂载开始时间
  req.beginTime = new Date().getTime()
  next()