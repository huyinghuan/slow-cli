(function() {
  module.exports = function(program, next) {
    if (!program.update) {
      return next();
    }
    console.log('update now!');
    return process.exit(1);
  };

}).call(this);
