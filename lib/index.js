(function() {
  var colors, current, pkg, version, _fs, _path, _program;

  _program = require('commander');

  _path = require('path');

  _fs = require('fs');

  colors = require('colors');

  require('sload').init(__dirname);

  pkg = _path.join(__dirname, '..', 'package.json');

  version = require(pkg).version;

  current = process.cwd();

  _program.version(version).option('init', 'init a slow project').option('-p, --port <n>', 'slow run in port <n>').option('-e, --env [value]', 'the environment that slow working,' + 'develop or product').option('build', "build project as a web project and " + "can don't depend on slow-cli anymore ").option('start', 'start slow server').option('update', 'update').parse(process.argv);

  sload('global')(_program, current, version);

  sload('bootstrap/index')(_program);

  if (!_fs.existsSync(SLOW.$currentDefaultConfigFilePath)) {
    console.log("you don't init slow. " + "please run slow init in the project directory.".yellow);
    current = _path.join(__dirname, '..', 'sample');
    console.log(("slow run defalut sample in " + current).blue);
  }

  sload('global')(_program, current, version);

  if (_program.start) {
    require('./app');
  }

}).call(this);
