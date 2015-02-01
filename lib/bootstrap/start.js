(function() {
  module.exports = function(program, next) {
    if (!program.start) {
      return next();
    }
    sload('global')(program);
    return sload('app');
  };

}).call(this);
