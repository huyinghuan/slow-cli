(function() {
  var $buildTarget, $config, doBuildCopy, doBuildIgnore, getPipeList, prepareConfig, _fs, _fse, _path;

  _fs = require('fs');

  _fse = require('fs-extra');

  _path = require('path');

  $config = SLOW._config_.build;

  $buildTarget = SLOW._config_.build.target;

  getPipeList = function() {
    var fileName, filePath, files, queue, _i, _len;
    queue = [];
    files = _fs.readdirSync(__dirname);
    for (_i = 0, _len = files.length; _i < _len; _i++) {
      fileName = files[_i];
      filePath = _path.join(__dirname, fileName);
      if (filePath === __filename) {
        continue;
      }
      if (_fs.statSync(filePath).isFile()) {
        queue.push(require(filePath));
      }
    }
    return queue;
  };

  prepareConfig = function(config) {
    var ignoreRules, rules;
    if (config instanceof RegExp) {
      config = {
        include: [config],
        ignore: []
      };
    }
    rules = [].concat(config.include || []);
    ignoreRules = [].concat(config.ignore || []);
    return {
      include: rules,
      ignore: ignoreRules
    };
  };

  doBuildIgnore = function(filename, buildFilename, next) {
    var rule, rules, _i, _len;
    rules = prepareConfig($config.ignore).include;
    for (_i = 0, _len = rules.length; _i < _len; _i++) {
      rule = rules[_i];
      if (rule.test(filename)) {
        return;
      }
    }
    if (filename.indexOf($buildTarget) === 0) {
      return;
    }
    if (filename.indexOf("/" + $buildTarget) === 0) {
      return;
    }
    return next(filename, buildFilename);
  };

  doBuildCopy = function(filename, buildFilename, next) {
    var buildTargetFilePath;
    if (buildFilename !== filename) {
      return;
    }
    buildTargetFilePath = _path.join($buildTarget, filename);
    return _fse.copySync(filename, buildTargetFilePath);
  };

  exports.doBuildCommon = function(filename, buildFilename, buildConfig, next, factory) {
    var ignoreRule, ignoreRules, rule, rules, _i, _j, _len, _len1;
    buildConfig = prepareConfig($config[buildConfig]);
    rules = buildConfig.include;
    ignoreRules = buildConfig.ignore;
    for (_i = 0, _len = ignoreRules.length; _i < _len; _i++) {
      ignoreRule = ignoreRules[_i];
      if (ignoreRule.test(filename)) {
        return next(filename, buildFilename);
      }
    }
    for (_j = 0, _len1 = rules.length; _j < _len1; _j++) {
      rule = rules[_j];
      if (rule.test(filename)) {
        return factory(filename);
      }
    }
    return next(filename, buildFilename);
  };

  exports.getPipeList = function() {
    var list;
    list = [doBuildIgnore];
    list = list.concat(getPipeList());
    list.push(doBuildCopy);
    return list;
  };

}).call(this);
