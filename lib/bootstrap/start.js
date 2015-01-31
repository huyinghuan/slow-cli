(function() {
  module.exports = function(program, next) {
    var configureFile, configureFilePath, current;
    if (!program.start) {
      return next();
    }
    configureFile = false;
    configureFilePath = false;
    if (program.run) {
      configureFilePath;
    }
    if (program.configure) {
      configureFilePath;
    }
    sload('global')(program, current, version);
    if (!_fs.existsSync(SLOW.$currentDefaultConfigFilePath)) {
      console.log("you don't init slow. " + "please run slow init in the project directory.".yellow);
      current = _path.join(__dirname, '..', 'sample');
      console.log(("slow run defalut sample in " + current).blue);
    }
    return sload('app');
  };

}).call(this);
