(function() {
  var Log;

  Log = require('log4slow');

  module.exports = function(req, resp, next) {
    var pathName;
    pathName = req.client.pathName;
    resp.on('finish', function() {
      var spellTime, startTime;
      startTime = req.beginTime;
      spellTime = new Date().getTime() - startTime;
      return Log.info("path ( " + pathName + " ):" + spellTime + " ms : [" + resp.statusCode + "]");
    });
    return next();
  };

}).call(this);
