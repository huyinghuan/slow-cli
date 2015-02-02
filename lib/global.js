(function() {
  var $defaultConfigDirectoryPath, $defaultConfigFilePath, $defaultDemoDirectory, $defaultRuntimeConfigureFilePath, $defaultRuntimeDirectory, $identity, $identityFile, $identityFilePath, initBuildGlobalConfig, initInitGlobalConfig, initRuntimeGlobalConfig, pkg, version, _fs, _path, _pathJudge;

  _path = require('path');

  _pathJudge = require('path-judge');

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

  initRuntimeGlobalConfig = function(program, setting) {
    var config, configEnv, env, runtimeConfigureFilePath, runtimeDirectory;
    runtimeDirectory = setting.runtimeDirectory;
    runtimeConfigureFilePath = setting.runtimeConfigureFilePath;
    if (!_fs.existsSync(runtimeConfigureFilePath)) {
      runtimeDirectory = $defaultDemoDirectory;
      runtimeConfigureFilePath = $defaultConfigFilePath;
      console.log("you have not init slow, " + "please run 'slow init' in the project directory \n" + "or set the project directory by 'slow -w path/to/project' \n" + "more information run 'slow -h'".yellow);
    }
    console.log(("slow run in " + runtimeDirectory).blue);
    config = require(runtimeConfigureFilePath);
    env = program.env || config.environment;
    configEnv = config[env];
    return global.SLOW = {
      version: config.version,
      _config_: config,
      _env_: config[env],
      port: program.port || configEnv.port,
      cwd: runtimeDirectory,
      base: configEnv.base,
      proxy: configEnv.proxy,
      env: env,
      log: configEnv.log,
      version: version,
      isProduct: function() {
        return env === 'product';
      }
    };
  };

  initInitGlobalConfig = function(program, setting) {
    var runtimeDirectory;
    runtimeDirectory = setting.runtimeDirectory;
    return global.SLOW = {
      $currentDefaultConfigFilePath: _path.join(runtimeDirectory, $identityFilePath),
      $currentDefaultConfigDirectoryPath: _path.join(runtimeDirectory, $identity),
      $defaultConfigDirectoryPath: $defaultConfigDirectoryPath
    };
  };

  initBuildGlobalConfig = function(program, setting) {
    var buildConfigure, buildConfigureFile, compileDir, configure, currentConfigureFilePath;
    if (program.source) {
      compileDir = _pathJudge.getFilePathBaseOnProcess(program.source);
    } else {
      compileDir = setting.runtimeDirectory;
    }
    if (program.buildConfigure) {
      buildConfigureFile = _pathJudge.getFilePathBaseOnProcess(buildConfigure);
    } else if (program.configure) {
      buildConfigureFile = _pathJudge.getFilePathBaseOnProcess(program.configure);
    } else if (_fs.existsSync(currentConfigureFilePath = _path.join(compileDir, $identityFilePath))) {
      buildConfigureFile = currentConfigureFilePath;
    } else {
      buildConfigureFile = $defaultConfigFilePath;
    }
    configure = require(buildConfigureFile);
    buildConfigure = configure.build || configure;
    if (program.output) {
      buildConfigure.target = _pathJudge.getFilePathBaseOnProcess(program.output);
    } else {
      buildConfigure.target = _pathJudge.getFilePathBaseOnProcess(buildConfigure.target);
    }
    console.log("Now compile config is " + buildConfigureFile);
    console.log("Now compile project in " + compileDir);
    return global.SLOW = {
      _config_: configure,
      version: buildConfigure.version,
      cwd: compileDir,
      build: buildConfigure
    };
  };

  module.exports = function(program) {
    var runtimeConfigureFilePath, runtimeDirectory, setting;
    runtimeConfigureFilePath = false;
    runtimeDirectory = false;
    if (program.workspace) {
      runtimeDirectory = _pathJudge.getFilePathBaseOnProcess(program.workspace);
    }
    if (program.configure) {
      runtimeConfigureFilePath = _pathJudge.getFilePathBaseOnProcess(program.configure);
    }
    runtimeDirectory = runtimeDirectory || $defaultRuntimeDirectory;
    $defaultRuntimeConfigureFilePath = _path.join(runtimeDirectory, $identityFilePath);
    runtimeConfigureFilePath = runtimeConfigureFilePath || $defaultRuntimeConfigureFilePath;
    setting = {
      runtimeDirectory: runtimeDirectory,
      runtimeConfigureFilePath: runtimeConfigureFilePath
    };
    if (program.start) {
      return initRuntimeGlobalConfig(program, setting);
    } else if (program.init) {
      return initInitGlobalConfig(program, setting);
    } else if (program.build) {
      return initBuildGlobalConfig(program, setting);
    }
  };

}).call(this);
