(function() {
  var $defaultConfigDirectoryPath, $defaultConfigFilePath, $defaultDemoDirectory, $defaultRuntimeConfigureFilePath, $defaultRuntimeDirectory, $identity, $identityFile, $identityFilePath, pkg, version, _fs, _path;

  _path = require('path');

  _fs = require('fs');

  pkg = _path.resolve(__dirname, '../package.json');

  version = require(pkg).version;

  $identity = ".slow";

  $identityFile = "config.js";

  $identityFilePath = _path.join($identity, $identityFile);

  $defaultConfigFilePath = _path.resolve(__dirname, "../sample", $identityFilePath);

  $defaultConfigDirectoryPath = _path.resolve(__dirname, "../sample", $identity);

  $defaultDemoDirectory = _path.resolve(__dirname, "../sample");

  $defaultRuntimeDirectory = process.cwd();

  $defaultRuntimeConfigureFilePath = false;

  module.exports = function(program, setting) {
    var config, configEnv, env, runtimeConfigureFilePath, runtimeDirectory;
    runtimeDirectory = setting.runtimeDirectory || $defaultRuntimeDirectory;
    $defaultRuntimeConfigureFilePath = _path.join(runtimeDirectory, $identityFilePath);
    runtimeConfigureFilePath = setting.runtimeConfigureFilePath || $defaultRuntimeConfigureFilePath;
    if (!_fs.existsSync(runtimeConfigureFilePath)) {
      runtimeDirectory = $defaultDemoDirectory;
      runtimeConfigureFilePath = $defaultConfigFilePath;
      console.log("you have not init slow, " + "please run 'slow init' in the project directory \n" + "or set the project directory by 'slow -r path/to/project' \n" + "more information run 'slow -h'".yellow);
    }
    console.log(("slow run in " + runtimeDirectory).blue);
    config = require(runtimeConfigureFilePath);
    env = program.env || config.environment;
    configEnv = config[env];
    return global.SLOW = {
      _config_: config,
      _env_: config[env],
      port: program.port || configEnv.port,
      cwd: runtimeDirectory,
      base: configEnv.base,
      proxy: configEnv.proxy,
      env: env,
      log: configEnv.log,
      version: version,
      $defaultConfigFilePath: $defaultConfigFilePath,
      $defaultConfigDirectoryPath: $defaultConfigDirectoryPath,
      isProduct: function() {
        return env === 'product';
      }
    };
  };

}).call(this);
