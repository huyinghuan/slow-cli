(function() {
  var _fse, _utils_file;

  _fse = require('fs-extra');

  _utils_file = require('./utils/file');

  module.exports = function(current, config) {
    return console.log(_utils_file.getAllFile(current));
  };

}).call(this);
