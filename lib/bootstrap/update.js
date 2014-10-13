(function() {
  var $current, $defConfigPath, $identify, copyConfig, _colors, _fs, _fse, _path;

  _path = require('path');

  _fse = require('fs-extra');

  _fs = require('fs');

  _colors = require('colors');

  $current = SLOW.cwd;

  $identify = SLOW.identify;

  $defConfigPath = SLOW._def_config_path_;

  copyConfig = function() {
    var configDirecotory, configFilename, configPath;
    configFilename = "config.js";
    configDirecotory = _path.join($current, $identify);
    configPath = _path.join(configDirecotory, configFilename);
    if (_fs.existsSync(configPath)) {
      _fse.copySync(configPath, _path.join(configDirecotory, "" + configFilename + ".bak"));
      return _fse.copySync(_path.join($defConfigPath, configFilename), _path.join(configDirecotory, configFilename));
    } else {
      return console.log("There isn't slow project.Please run `slow init` at first.".yellow);
    }
  };

  module.exports = function(program, next) {
    console.log(1);
    return process.exit(1);
  };

}).call(this);
