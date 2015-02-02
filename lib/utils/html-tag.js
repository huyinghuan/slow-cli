(function() {
  var Tag, generateScriptTag, generateStyleTag, generateTags, version;

  version = SLOW.version ? "?v=" + SLOW.version : "";

  Tag = module.exports = {};

  generateScriptTag = function(src) {
    src = src.replace(/(coffee)$/, 'js');
    return "<script src='" + src + version + "'></script>";
  };

  generateStyleTag = function(href) {
    href = href.replace(/(less)$/, 'css');
    return "<link href='" + href + version + "' rel='stylesheet' type='text/css'>";
  };

  generateTags = function(filePaths, root) {
    var cssReg, jsReg, queue, uri, _i, _len;
    if (root == null) {
      root = '/';
    }
    cssReg = /(\.css|\.less)$/;
    jsReg = /(\.js|\.coffee)$/;
    if (root !== '' && !/\/$/.test(root)) {
      root = "" + root + "/";
    }
    queue = [];
    for (_i = 0, _len = filePaths.length; _i < _len; _i++) {
      uri = filePaths[_i];
      if (jsReg.test(uri)) {
        queue.push(generateScriptTag("" + root + uri));
      }
      if (cssReg.test(uri)) {
        queue.push(generateStyleTag("" + root + uri));
      }
    }
    return queue.join('\n');
  };

  Tag.generateScriptTag = generateScriptTag;

  Tag.generateStyleTag = generateStyleTag;

  Tag.generateTags = generateTags;

}).call(this);
