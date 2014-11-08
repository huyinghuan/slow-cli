(function() {
  var $currentDefaultConfigDirectoryPath, $currentDefaultConfigFilePath, $defaultConfigDirectoryPath, $defaultConfigFilePath, $identity, $identityFile, $identityFilePath, _fs, _path;

  _path = require('path');

  _fs = require('fs');

  $identity = ".slow";

  $identityFile = "config.js";

  $identityFilePath = _path.join($identity, $identityFile);

  $defaultConfigFilePath = _path.join(__dirname, "..", "sample", $identityFilePath);

  $defaultConfigDirectoryPath = _path.join(__dirname, "..", "sample", $identity);

  $currentDefaultConfigFilePath = _path.join(process.cwd(), $identityFilePath);

  $currentDefaultConfigDirectoryPath = _path.join(process.cwd(), $identity);

  module.exports = function(program, current, version) {
    var config, configEnv, configFilePath, env;
    configFilePath = _path.join(current, $identityFilePath);
    if (!_fs.existsSync(configFilePath)) {
      configFilePath = $defaultConfigFilePath;
    }
    config = require(configFilePath);
    env = program.env || config.environment;
    configEnv = config[env];
    return global.SLOW = {
      _config_: config,
      _env_: config[env],
      _def_config_path_: $defaultConfigFilePath,
      port: program.port || configEnv.port,
      cwd: current,
      base: configEnv.base,
      proxy: configEnv.proxy,
      env: env,
      log: configEnv.log,
      version: version,
      $defaultConfigFilePath: $defaultConfigFilePath,
      $defaultConfigDirectoryPath: $defaultConfigDirectoryPath,
      $currentDefaultConfigFilePath: $currentDefaultConfigFilePath,
      $currentDefaultConfigDirectoryPath: $currentDefaultConfigDirectoryPath,
      isProduct: function() {
        return env === 'product';
      }
    };
  };

}).call(this);
