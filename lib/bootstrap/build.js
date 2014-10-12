(function() {
  var buildFile, buildTarget, checkLegalProject, config, current, cwd, doBuildCommon, doBuildCompileCoffee, doBuildCompileHbs, doBuildCompileLess, doBuildCopy, doBuildIgnore, end, getBuildList, isReg, prepareConfig, replaceFileExt, _coffee, _fs, _fse, _handlebar, _less, _path, _utils_file;

  _fse = require('fs-extra');

  _fs = require('fs');

  _path = require('path');

  _coffee = require('coffee-script');

  _less = require('less');

  _utils_file = require('../utils/file');

  _handlebar = require('../utils/handlebar');

  current = SLOW.cwd;

  config = SLOW._config_.build;

  buildTarget = config.target;

  cwd = process.cwd();

  isReg = function(o) {
    return o instanceof RegExp;
  };

  replaceFileExt = function(filename, ext) {
    if (filename.indexOf(".") === -1) {
      return "" + filename + "." + ext;
    }
    return filename.substr(0, filename.lastIndexOf('.')) + ("." + ext);
  };

  prepareConfig = function(config) {
    var ignoreRules, rules;
    if (isReg(config)) {
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

  end = function() {
    return process.exit(1);
  };

  doBuildCommon = function(filename, buildFilename, buildConfig, next, factory) {
    var ignoreRule, ignoreRules, rule, rules, _i, _j, _len, _len1;
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

  doBuildIgnore = function(filename, buildFilename, next) {
    var rule, rules, _i, _len;
    rules = prepareConfig(config.ignore).include;
    for (_i = 0, _len = rules.length; _i < _len; _i++) {
      rule = rules[_i];
      if (rule.test(filename)) {
        return;
      }
    }
    if (filename.indexOf(buildTarget) === 0) {
      return;
    }
    if (filename.indexOf("/" + buildTarget) === 0) {
      return;
    }
    return next(filename, buildFilename);
  };

  doBuildCompileHbs = function(filename, buildFilename, next) {
    var buildConfig, factory;
    factory = function(filename) {
      var buildTargetFilePath, buildTargetFilename, content;
      buildTargetFilename = replaceFileExt(filename, "html");
      buildTargetFilePath = _path.join(buildTarget, buildTargetFilename);
      _fse.ensureFileSync(buildTargetFilePath);
      content = _handlebar.compileFileSync(_path.join(cwd, filename));
      _fse.outputFileSync(buildTargetFilePath, content);
      return next(filename, buildTargetFilePath);
    };
    buildConfig = prepareConfig(config.hbsCompile);
    return doBuildCommon(filename, buildFilename, buildConfig, next, factory);
  };

  doBuildCompileLess = function(filename, buildFilename, next) {
    var buildConfig, factory;
    factory = function(filename) {
      var buildTargetFilePath, buildTargetFilename, content;
      buildTargetFilename = replaceFileExt(filename, "css");
      buildTargetFilePath = _path.join(buildTarget, buildTargetFilename);
      _fse.ensureFileSync(buildTargetFilePath);
      content = _fs.readFileSync(_path.join(cwd, filename), {
        encoding: "utf8"
      });
      return _less.render(content, function(e, css) {
        _fse.outputFileSync(buildTargetFilePath, css);
        return next(filename, buildTargetFilePath);
      });
    };
    buildConfig = prepareConfig(config.lessCompile);
    return doBuildCommon(filename, buildFilename, buildConfig, next, factory);
  };

  doBuildCompileCoffee = function(filename, buildFilename, next) {
    var buildConfig, factory;
    factory = function(filename) {
      var buildTargetFilePath, buildTargetFilename, content;
      buildTargetFilename = replaceFileExt(filename, "js");
      buildTargetFilePath = _path.join(buildTarget, buildTargetFilename);
      _fse.ensureFileSync(buildTargetFilePath);
      content = _fs.readFileSync(_path.join(cwd, filename), {
        encoding: "utf8"
      });
      _fse.outputFileSync(buildTargetFilePath, _coffee.compile(content));
      return next(filename, buildTargetFilePath);
    };
    buildConfig = prepareConfig(config.coffeeCompile);
    return doBuildCommon(filename, buildFilename, buildConfig, next, factory);
  };

  doBuildCopy = function(filename, buildFilename, next) {
    var buildTargetFilePath;
    if (buildFilename !== filename) {
      return;
    }
    buildTargetFilePath = _path.join(buildTarget, filename);
    return _fse.copySync(filename, buildTargetFilePath);
  };

  getBuildList = function() {
    return [doBuildIgnore, doBuildCompileHbs, doBuildCompileLess, doBuildCompileCoffee, doBuildCopy];
  };

  checkLegalProject = function(program) {
    if (program.isNormalProject) {
      return true;
    }
    console.log("Can't build project in SLOW sample");
    return false;
  };

  buildFile = function(file) {
    var list, next, path;
    path = file.replace("" + current + "/", "");
    list = getBuildList();
    next = function(filename, buildFilename) {
      var build;
      build = list.shift();
      if (build) {
        return build(filename, buildFilename, next);
      }
    };
    return next(path, path);
  };

  module.exports = function(program, next) {
    var allFils, filename, _i, _len;
    if (!program.build) {
      return next();
    }
    console.log('Building...');
    if (!checkLegalProject(program)) {
      return end();
    }
    allFils = _utils_file.getAllFile(current);
    for (_i = 0, _len = allFils.length; _i < _len; _i++) {
      filename = allFils[_i];
      buildFile(filename);
    }
    return process.exit(1);
  };

}).call(this);
