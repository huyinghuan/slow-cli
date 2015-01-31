(function() {
  var colors, _path, _sload;

  _sload = require('sload');

  _path = require('path');

  colors = require('colors');

  module.exports = function(program) {
    var next, straps;
    straps = _sload.scan(__dirname, {
      ignore: function(filename) {
        return _path.join(__dirname, filename) === __filename;
      }
    });
    next = function() {
      var step;
      step = straps.pop();
      if (step) {
        return step(program, next);
      } else {
        return console.log('Error! Invalid optional!');
      }
    };
    return next();
  };

}).call(this);
