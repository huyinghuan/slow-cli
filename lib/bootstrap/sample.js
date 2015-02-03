(function() {
  module.exports = function(program, next) {
    if (!program.sample) {
      return next();
    }
    return sload('app');
  };

}).call(this);
