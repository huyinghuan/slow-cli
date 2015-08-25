#第一个中间件 记录接受到http请求的时间
module.exports = (req, resp, next)->
  #挂载开始时间
  req.beginTime = new Date().getTime()
  next()
