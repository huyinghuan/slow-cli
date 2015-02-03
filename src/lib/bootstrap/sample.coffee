module.exports = (program, next)->
  return next() if not program.sample
  sload('app')