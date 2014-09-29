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
      if (resp.statusCode === 200) {
        return Log.info(msg);
      } else {
        return Log.error(msg);
      }
    });
    return next();
  };

}).call(this);
