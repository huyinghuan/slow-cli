_httpProxy = require('http-proxy').createProxyServer()

module.exports = (req, resp, next)->
  pathName = req.client.pathName
  proxySetting = SLOW.proxy
  proxyPath = proxySetting.path
  return next() if not proxyPath.test pathName
  _httpProxy.web(req, resp, proxySetting.options, ()->
    resp.throwsServerError()
  )
