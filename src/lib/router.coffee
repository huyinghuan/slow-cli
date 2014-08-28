URLExtra = require './utils/url-extra'
_fileType = require './utils/file-type'

module.exports =  (req, resp, next)->
  url = new URLExtra req
  pathName = url.getPathName()
  #console.log req.headers
  #resp.end 'hello'
  #....
  next()


