(function() {
  var _pathJudge;

  _pathJudge = require('path-judge');

  module.exports = function(program, next) {
    var configureFilePath, runtimeDirectory;
    if (!program.start) {
      return next();
    }
    configureFilePath = false;
    runtimeDirectory = false;
    if (program.workspace) {
      runtimeDirectory = _pathJudge.getFilePathBaseOnProcess(program.workspace);
    }
    if (program.configure) {
      configureFilePath = _pathJudge.getFilePathBaseOnProcess(program.configure);
    }
    sload('global')(program, {
      runtimeDirectory: runtimeDirectory,
      runtimeConfigureFilePath: configureFilePath
    });
    return sload('app');
  };

}).call(this);
