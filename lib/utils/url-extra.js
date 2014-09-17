(function() {
  var URLExtra, _url;

  _url = require('url');

  URLExtra = (function() {
    function URLExtra(req) {
      this.init(req);
    }

    URLExtra.prototype.init = function(req) {
      return this.data = _url.parse(req.url, true, true);
    };

    URLExtra.prototype.get = function(param) {
      if (param) {
        return this.data[param];
      } else {
        return this.data;
      }
    };

    URLExtra.prototype.getPathName = function() {
      return this.get('pathname');
    };

    URLExtra.prototype.getQuery = function() {
      return this.get('query');
    };

    URLExtra.prototype.getHref = function() {
      return this.get('href');
    };

    return URLExtra;

  })();

  module.exports = URLExtra;

}).call(this);
