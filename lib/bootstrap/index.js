(function() {
  var _path, _sload;

  _sload = require('sload');

  _path = require('path');

  module.exports = function(program) {
    var next, straps;
    straps = _sload.scan(__dirname, {
      ignore: function(filename) {
        return _path.join(__dirname, filename) === __filename;
      }
    });
    next = function() {
      var config;
      config = straps.pop();
      if (config) {
        return config(program, next);
      }
    };
    return next();
  };

}).call(this);
