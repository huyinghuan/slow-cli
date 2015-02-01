module.exports = (program, next)->
  return next() if not program.start
  sload('app')