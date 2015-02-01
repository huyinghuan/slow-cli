(function() {
  var colors, pkg, version, _fs, _path, _program;

  _program = require('commander');

  _path = require('path');

  _fs = require('fs');

  colors = require('colors');

  require('sload').init(__dirname);

  pkg = _path.resolve(__dirname, '../package.json');

  version = require(pkg).version;

  _program.version(version).option('init', 'init a slow project').option('-p, --port <n>', 'slow run in port <n>').option('-e, --env [value]', 'the environment that slow working,' + 'develop or product').option('-s, --source [value]', 'compile source directory').option('-o, --output [value]', 'output directory after compiled').option('-c, --configure [value]', 'the configure file').option('-b, --buildConfigure [value]', 'the configure for build').option('-w, --workspace [value]', 'the project workspace').option('build', "build project as a web project and " + "can don't depend on slow-cli anymore ").option('start', 'start slow server').option('update', 'update').parse(process.argv);

  sload('bootstrap/index')(_program);

}).call(this);
