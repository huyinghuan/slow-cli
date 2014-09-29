(function() {
  var _fse;

  _fse = require('fs-extra');

  module.exports = function(current, config) {
    var buildPath;
    buildPath = _path.join(current, config.build.target);
    return _fse.mkdirpSync(buildPath);
  };

}).call(this);
