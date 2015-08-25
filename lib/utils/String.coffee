String = module.exports = {}

String.isEmpty = (str)->
  return true if str is null or str is undefined
  str = str.toString()
  str = str.replace /\s/g, ''
  return not str.length