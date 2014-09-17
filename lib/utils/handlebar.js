(function() {
  var Handlebar, WebGlobal, compileFile, compileFileSync, getTemplateContent, isNeedCompile, _Handlebars, _async, _fs, _glob, _path, _tag, _util_file;

  _fs = require('fs');

  _Handlebars = require('handlebars');

  _async = require('async');

  _path = require('path');

  _util_file = require('./file');

  _glob = require('glob');

  _tag = require('./html-tag');

  WebGlobal = {};

  isNeedCompile = function(filePath) {
    return !/(\.html)$/.test(filePath);
  };

  compileFile = function(filePath, cb) {
    var queue;
    queue = [];
    queue.push(function(next) {
      return _fs.readFile(filePath, {
        encoding: 'utf8'
      }, function(err, data) {
        return next(err, data);
      });
    });
    queue.push(function(content, next) {
      var template;
      if (!isNeedCompile(filePath)) {
        return next(null, content);
      }
      template = _Handlebars.compile(content);
      return next(null, template(WebGlobal));
    });
    return _async.waterfall(queue, cb);
  };

  compileFileSync = function(filePath, context) {
    var html, template;
    if (context == null) {
      context = WebGlobal;
    }
    html = _fs.readFileSync(filePath, 'utf8');
    if (!isNeedCompile(filePath)) {
      return html;
    }
    template = _Handlebars.compile(html);
    return template(context);
  };

  getTemplateContent = function(fileName, context) {
    var filePath, html;
    if (context == null) {
      context = {};
    }
    filePath = _path.join(__dirname, "handlebar-template", fileName);
    filePath = "" + filePath + ".html";
    html = compileFileSync(filePath, context);
    return new _Handlebars.SafeString(html);
  };

  _Handlebars.registerHelper('watch_file', function() {
    if (SLOW.isProduct()) {
      return '';
    }
    return getTemplateContent("watch-file");
  });

  _Handlebars.registerHelper('import', function(filePath) {
    var flag, html, origin_path, reg;
    origin_path = filePath;
    filePath = _util_file.getFilePath(filePath);
    reg = /(\.html|\.hbs)$/;
    if (!reg.test(filePath)) {
      filePath = "" + filePath + ".html";
    }
    flag = _fs.existsSync(filePath);
    if (!flag) {
      filePath = filePath.replace(/(\.html)$/, '.hbs');
      if (!_fs.existsSync(filePath)) {
        return getTemplateContent("no-file-found", {
          filePath: origin_path
        });
      }
    }
    html = compileFileSync(filePath);
    return new _Handlebars.SafeString(html);
  });

  _Handlebars.registerHelper('include', function(files) {
    var tags;
    tags = _tag.generateTags(_util_file.getMatchFilesQueue(files));
    return new _Handlebars.SafeString(tags);
  });

  Handlebar = module.exports = {};

  Handlebar.compileFile = compileFile;

  Handlebar.compileFileSync = compileFileSync;

}).call(this);
