(function() {
  var String;

  String = module.exports = {};

  String.isEmpty = function(str) {
    if (str === null || str === void 0) {
      return true;
    }
    str = str.toString();
    str = str.replace(/\s/g, '');
    return !str.length;
  };

}).call(this);
