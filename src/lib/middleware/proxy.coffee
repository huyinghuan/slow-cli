#代理的相关配置
proxySetting = SLOW.proxy

#需要代理的路径
proxyPath = proxySetting.path

proxyOptions = proxySetting.options

proxyURL = proxyOptions.target or proxyOptions.forward #获取实际代理地址

_httpProxy = require('http-proxy').createProxyServer()

console.log "Server proxy #{proxyPath} to #{proxyURL}" if proxyURL

module.exports = (req, resp, next)->
  pathName = req.client.pathName
  return next() if not proxySetting #如果没配置
  return next() if not proxyPath.test pathName #如果路径没有匹配上

  console.log "#{pathName} #{req.method} -> #{proxyURL}"

  _httpProxy.web(req, resp, proxyOptions, (e)->
    console.log e
    resp.throwsServerError()
  )
