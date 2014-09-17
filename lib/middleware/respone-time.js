(function() {
  var Log;

  Log = require('log4slow');

  module.exports = function(req, resp, next) {
    var pathName, startTime;
    startTime = req.beginTime;
    pathName = req.client.pathName;
    resp.on('finish', function() {
      var spellTime;
      spellTime = new Date().getTime() - startTime;
      return Log.info("path ( " + pathName + " ):" + spellTime + " ms");
    });
    return next();
  };

}).call(this);
