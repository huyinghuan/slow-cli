module.exports = (program, next)->
  return next() if !program.update
  console.log 'update now!'
  process.exit 1