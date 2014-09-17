(function() {
  var Tag, generateScriptTag, generateStyleTag, generateTags;

  Tag = module.exports = {};

  generateScriptTag = function(src) {
    return "<script src='" + src + "'></script>";
  };

  generateStyleTag = function(href) {
    return "<link href='" + href + "' rel='stylesheet' type='text/css'>";
  };

  generateTags = function(filePaths) {
    var cssReg, jsReg, queue, uri, _i, _len;
    cssReg = /(\.css|\.less)$/;
    jsReg = /(\.js|\.coffee)$/;
    queue = [];
    for (_i = 0, _len = filePaths.length; _i < _len; _i++) {
      uri = filePaths[_i];
      if (jsReg.test(uri)) {
        queue.push(generateScriptTag(uri));
      }
      if (cssReg.test(uri)) {
        queue.push(generateStyleTag(uri));
      }
    }
    return queue.join('\n');
  };

  Tag.generateScriptTag = generateScriptTag;

  Tag.generateStyleTag = generateStyleTag;

  Tag.generateTags = generateTags;

}).call(this);
