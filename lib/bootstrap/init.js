(function() {
  var _fse;

  _fse = require('fs-extra');

  module.exports = function(program, next) {
    if (!program.init) {
      return next();
    }
    _fse.ensureFileSync(SLOW.$currentDefaultConfigFilePath);
    _fse.copySync(SLOW.$defaultConfigFilePath, SLOW.$currentDefaultConfigFilePath);
    return process.exit(1);
  };

}).call(this);
