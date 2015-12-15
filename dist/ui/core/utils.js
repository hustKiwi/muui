define(function() {
  var StrProto;
  StrProto = String.prototype;
  if (!_.isFunction(StrProto.startsWith)) {
    StrProto.startsWith = function(str) {
      return this.slice(0, str.length) === str;
    };
  }
  if (!_.isFunction(StrProto.endsWith)) {
    StrProto.endsWith = function(str) {
      return this.slice(-str.length) === str;
    };
  }
  return {
    api: function(url, data, options) {
      var def, defaults, opts;
      def = $.Deferred();
      defaults = {
        type: 'GET',
        dataType: 'jsonp',
        handleError: function(r) {
          return typeof console !== "undefined" && console !== null ? typeof console.error === "function" ? console.error(r) : void 0 : void 0;
        }
      };
      if (_.isObject(url)) {
        options = data;
        data = url.data;
        url = url.url;
      }
      opts = $.extend(defaults, options);
      if (data == null) {
        data = {};
      }
      $.ajax({
        url: url,
        data: data,
        dataType: opts.dataType,
        type: opts.type,
        success: function(r) {
          return def.resolve(r);
        },
        error: function() {
          var msg;
          msg = 'ajax error';
          def.reject(msg);
          return opts.handleError(msg);
        }
      });
      return def.promise();
    },
    isTemplate: function(tmpl) {
      return _.isFunction(tmpl) && 'source' in tmpl;
    }
  };
});
