_ = require 'lodash'
#代理的相关配置
proxySetting = SLOW.proxy

_httpProxy = require('http-proxy').createProxyServer()

logProxyInfo = ()->
  return if not proxySetting
  queue = [].concat(proxySetting)
  for proxy in queue
    proxyURL = proxy.options.target or proxy.option.forward
    console.log "Server proxy #{proxy.path} to #{proxyURL}"

logProxyInfo()

getProxyURL = (pathName)->
  queue = []
  if _.isPlainObject proxySetting
    queue = [proxySetting]
  else if _.isArray proxySetting
    queue = proxySetting

  for proxy in queue
    if proxy.path.test pathName
      return proxy

  return false


module.exports = (req, resp, next)->
  pathName = req.client.pathName
  return next() if not proxySetting #如果没配置

  proxy = getProxyURL(pathName)

  return next() if proxy is false
  proxyURL =  proxy.options.target or proxy.options.forward

  console.log "#{pathName} #{req.method} -> #{proxyURL}"

  _httpProxy.web(req, resp, proxy.options, (e)->
    resp.throwsServerError()
  )
