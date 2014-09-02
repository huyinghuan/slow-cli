# 不存在的资源的处理
module.exports = (req, resp)->
  resp.statusCode = 404
  resp.end()