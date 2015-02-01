(function() {
  module.exports = function(program, next) {
    if (!program.start) {
      return next();
    }
    return sload('app');
  };

}).call(this);
