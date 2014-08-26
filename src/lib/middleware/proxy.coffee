module.exports = (rep, resp, next)->
  console.log 'proxy'
  resp.end 'hello2'