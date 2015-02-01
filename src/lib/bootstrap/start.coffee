module.exports = (program, next)->
  return next() if not program.start
  #更新全局变量
  sload('global')(program)
  sload('app')