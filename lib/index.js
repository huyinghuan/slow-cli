(function() {
  var colors, identity, _fs, _fse, _path, _program;

  _program = require('commander');

  _path = require('path');

  _fse = require('fs-extra');

  _fs = require('fs');

  colors = require('colors');

  identity = '.slow';

  module.exports = function() {
    var current, pkg, sample, version;
    pkg = _path.join(__dirname, '..', 'package.json');
    version = require(pkg).version;
    _program.version(version).option('init', 'init a slow project').option('-p, --port <n>', 'slow run in port <n>').option('-e, --env [value]', 'the environment that slow working,' + 'develop or product').option('build', "build project as a web project and " + "can don't depend on slow-cli anymore ").option('update', 'update').parse(process.argv);
    current = process.cwd();
    if (_program.init) {
      sample = _path.join(__dirname, '..', 'sample', identity);
      _fse.copySync(sample, _path.join(current, identity));
      process.exit(1);
    }
    _program.isNormalProject = true;
    if (!_fs.existsSync(_path.join(current, identity))) {
      console.log("you don't init slow. " + "please run slow init in the project directory.".yellow);
      current = _path.join(__dirname, '..', 'sample');
      console.log(("slow run defalut sample in " + current).blue);
      _program.isNormalProject = false;
    }
    require('./global')(_program, current, version);
    require('./bootstrap/index')(_program);
    return require('../lib/app');
  };

}).call(this);
