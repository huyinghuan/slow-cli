(function() {
  var Log, identity, _fs, _fse, _path, _program;

  _program = require('commander');

  _path = require('path');

  _fse = require('fs-extra');

  _fs = require('fs');

  Log = require('log4slow');

  identity = '.slow';

  module.exports = function() {
    var config, current, env, pkg, sample, slow, version;
    pkg = _path.join(__dirname, '..', 'package.json');
    version = require(pkg).version;
    _program.version(version).option('init', 'init a slow project').option('-p, --port <n>', 'slow run in port <n>').option('-e, --env [value]', 'the environment that slow working, develop or product').parse(process.argv);
    current = process.cwd();
    if (_program.init) {
      sample = _path.join(__dirname, '..', 'sample');
      _fse.copySync(sample, _path.join(current));
      process.exit(1);
    }
    if (!_fs.existsSync(_path.join(current, identity))) {
      Log.warn("you do not init slow. please run slow init in the project directory.");
      current = _path.join(__dirname, '..', 'sample');
      Log.info("slow run defalut sample in " + current);
    }
    config = require(_path.join(current, identity, "config"));
    env = _program.env || config.environment;
    config = config[env];
    slow = global.SLOW = {};
    slow.port = _program.port || config.port;
    slow.cwd = current;
    slow.base = config.base;
    slow.env = env;
    slow.isProduct = function() {
      return env === 'product';
    };
    return require('../lib/app');
  };

}).call(this);
