(function() {
  var _fse;

  _fse = require('fs-extra');

  module.exports = function(program, next) {
    if (!program.init) {
      return next();
    }
    sload('global')(program);
    _fse.ensureFileSync(SLOW.$currentDefaultConfigFilePath);
    _fse.copySync(SLOW.$defaultConfigDirectoryPath, SLOW.$currentDefaultConfigDirectoryPath);
    return process.exit(1);
  };

}).call(this);
