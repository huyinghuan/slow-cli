_url = require 'url'
class URLExtra
  constructor: (req)->
    @init(req)

  init: (req)->
    @data = _url.parse req.url, true, true

  get: (param)->
    if param then @data[param] else @data

  getPathName: ->
    @get 'pathname'

  getQuery: ->
    @get 'query'

  getHref: ->
    @get 'href'


module.exports = URLExtra