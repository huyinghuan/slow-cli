require('es6-promise').polyfill()
_postcss = require 'postcss'
_autoprefixer = require 'autoprefixer'
_ = require 'lodash'

_cleaner  = _postcss([_autoprefixer({ add: false, browsers: [] }) ])


_isAutoPrefixer = SLOW.plugins.autoprefixer #是否增加浏览器兼容

module.exports = (content, cb)->
  return cb(null, content) if not _isAutoPrefixer

  options = if _.isPlainObject(_isAutoPrefixer) then _isAutoPrefixer else {}

  prefixer = _postcss([_autoprefixer(options)])
  _cleaner.process(content)
    .then((cleaned)->
      prefixer.process(cleaned.css)
    )
    .then((result)->
      cb(null, result.css)
    )
    .catch((e)->
      console.warn("AutoprefixProcessor has error")
      cb(e)
    )
