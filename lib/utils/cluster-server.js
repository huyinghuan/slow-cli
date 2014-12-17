(function() {
  var ClusterServer, cluster, os;

  cluster = require('cluster');

  os = require('os');

  ClusterServer = (function() {
    function ClusterServer(autoRestart, workerNumber) {
      this.autoRestart = autoRestart || true;
      this.workerNumber = workerNumber || os.cpus().length;
    }

    ClusterServer.prototype.start = function(server, port) {
      var i, self, _i, _ref;
      self = this;
      if (!cluster.isMaster) {
        return server.listen(port);
      }
      for (i = _i = 1, _ref = this.workerNumber; 1 <= _ref ? _i <= _ref : _i >= _ref; i = 1 <= _ref ? ++_i : --_i) {
        console.log("slow", "#1");
        cluster.fork();
      }
      return cluster.on('death', function(worker) {
        console.log("slow " + worker.pid + " died");
        if (self.autoRestart) {
          return cluster.fork();
        }
      });
    };

    return ClusterServer;

  })();

  module.exports = ClusterServer;

}).call(this);
