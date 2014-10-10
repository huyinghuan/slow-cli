(function() {
  var _path;

  _path = require('path');

  module.exports = function(program, current, version, identity) {
    var config, configEnv, env;
    if (identity == null) {
      identity = '.slow';
    }
    config = require(_path.join(current, identity, "config"));
    env = program.env || config.environment;
    configEnv = config[env];
    return global.SLOW = {
      _config_: config,
      _env_: config[env],
      port: program.port || configEnv.port,
      cwd: current,
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

}).call(this);
