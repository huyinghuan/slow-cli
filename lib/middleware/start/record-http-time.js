(function() {
  module.exports = function(req, resp, next) {
    req.beginTime = new Date().getTime();
    return next();
  };

}).call(this);