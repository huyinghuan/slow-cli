template =
'''
    <script src="/socket.io/socket.io.js"></script>
    <script>
      var socket = io(window.location.origin);
      var refreshAssets;
      socket.on('file-change', function (data) {
        if(window.location.pathname === data){
          window.location.reload()
        }else{
          refreshAssets(data, function(){window.location.reload()})
        }
      });
      refreshAssets = function(data, cb){
        var ext = data.replace(/.*\.(js|css|png|gif|jpg|jpeg|ico)$/, '$1');
        var selector, tagAttrs;
        if(ext === 'js'){
          selector = 'script';
          tagAttrs = 'src'
        }else if(ext === 'css'){
          selector = 'link[type="text/css"]';
          tagAttrs = 'href'
        }else if("png,gif,jpg,jpeg,ico".indexOf(ext) !== -1){
          selector = 'img';
          tagAttrs = 'src';
        }else{
          selector = false;
        }
        if(!selector) return;
        var nodes = document.querySelectorAll(selector);
        var hasMatch = false;
        for(var i = 0, length = nodes.length; i < length; i++){
          var node = nodes[i];
          var attr = node[tagAttrs];
          if(!attr || attr.indexOf(data) === -1){
            continue;
          }
          if(selector === 'script'){
            cb && cb();
            continue;
          }
          var query = "refreshTime=" + new Date().getTime();
          if(attr.indexOf('?') === -1){
            node[tagAttrs] = attr + "?" + query
          }else{
            node[tagAttrs] = attr.replace(/&?refreshTime=.*$/, '') + "&" + query
          }
          hasMatch = true
        }
        if(!hasMatch){
          cb && cb();
        }
      }
    </script>
'''


module.exports = (Handlebars)->
  helpName = 'livereload'
  Handlebars.unregisterHelper helpName
  Handlebars.registerHelper helpName, -> new Handlebars.SafeString template