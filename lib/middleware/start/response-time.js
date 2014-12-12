(function() {
  var Log;

  Log = require('log4slow');

  Log.init(SLOW.log);

  module.exports = function(req, resp, next) {
    var pathName;
    pathName = req.client.pathName;
    resp.on('finish', function() {
      var msg, spellTime, startTime;
      startTime = req.beginTime;
      spellTime = new Date().getTime() - startTime;
      msg = "( " + pathName + " ):" + spellTime + " ms : [" + resp.statusCode + "]";
      if (!SLOW.base.showResponseTime) {
        return;
      }
      switch (resp.statusCode) {
        case 200:
        case 304:
          return Log.info(msg);
        case 401:
        case 403:
        case 404:
        case 500:
          return Log.error(msg);
        default:
          return Log.info(msg);
      }
    });
    return next();
  };

}).call(this);
