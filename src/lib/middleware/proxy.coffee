module.exports = (rep, resp, next)->
  console.log 'proxy'
  next()