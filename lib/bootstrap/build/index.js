(function() {
  var $buildTarget, $config, doBuildCopy, doBuildIgnore, getMiddleList, getModuleList, prepareConfig, _, _fs, _fse, _path;

  _fs = require('fs');

  _fse = require('fs-extra');

  _path = require('path');

  _ = require('lodash');

  $config = SLOW._config_.build;

  $buildTarget = SLOW._config_.build.target;

  getMiddleList = function(dir) {
    var fileName, filePath, files, queue, _i, _len;
    queue = [];
    files = _fs.readdirSync(dir);
    for (_i = 0, _len = files.length; _i < _len; _i++) {
      fileName = files[_i];
      filePath = _path.join(dir, fileName);
      if (_fs.statSync(filePath).isFile()) {
        queue.push(require(filePath));
      }
    }
    return queue;
  };

  getModuleList = function() {
    var queue;
    queue = [];
    queue = queue.concat(getMiddleList(_path.join(__dirname, 'prepare')));
    queue = queue.concat(getMiddleList(_path.join(__dirname, 'normal')));
    return queue;
  };

  prepareConfig = function(config) {
    var ignoreRules, rules;
    if (_.isRegExp(config) || _.isArray(config)) {
      config = {
        include: [].concat(config),
        ignore: []
      };
    }
    rules = [].concat(config.include || []);
    ignoreRules = [].concat(config.ignore || []);
    config.include = rules;
    config.ignore = ignoreRules;
    return config;
  };

  doBuildIgnore = function(filename, buildFilename, next) {
    var rule, rules, _i, _len;
    if (!$config.ignore) {
      return next(filename, buildFilename);
    }
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
    var ignoreRule, ignoreRules, isMatchFile, rule, rules, _i, _j, _len, _len1;
    if (!$config[buildConfig]) {
      return next(filename, buildFilename);
    }
    buildConfig = prepareConfig($config[buildConfig]);
    rules = buildConfig.include;
    ignoreRules = buildConfig.ignore;
    isMatchFile = false;
    for (_i = 0, _len = rules.length; _i < _len; _i++) {
      rule = rules[_i];
      if (!_.isRegExp(rule)) {
        continue;
      }
      if (rule.test(filename)) {
        isMatchFile = true;
        break;
      }
    }
    if (!isMatchFile) {
      return next(filename, buildFilename);
    }
    for (_j = 0, _len1 = ignoreRules.length; _j < _len1; _j++) {
      ignoreRule = ignoreRules[_j];
      if (!_.isRegExp(ignoreRule)) {
        continue;
      }
      if (ignoreRule.test(filename)) {
        return next(filename, buildFilename);
      }
    }
    return factory(filename);
  };

  exports.getPipeList = function() {
    var list;
    list = [doBuildIgnore];
    list = list.concat(getModuleList());
    list = list.concat(doBuildCopy);
    return list;
  };

}).call(this);