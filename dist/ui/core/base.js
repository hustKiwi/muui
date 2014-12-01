var __slice = [].slice;

define(['muui/core/utils'], function(utils) {
  var $html, MuUI;
  $html = $('html');
  MuUI = (function() {
    MuUI.defaults = {
      el: '',
      datasource: '',
      render_args: {},
      render_fn: 'replaceWith',
      data_filter: function(r) {
        return r;
      },
      before_render: function() {},
      after_render: function() {}
    };

    MuUI.prototype.get_opts = function() {
      return MuUI.defaults;
    };

    function MuUI(options) {
      var opts;
      this._jq = $({});
      this.opts = opts = this.get_opts(options);
      if (!opts.el) {
        throw new Error('el cannot be empty.');
      }
      this.$el = $(opts.el);
      this.before_render();
      opts.before_render.apply(this);
      this.trigger('before_render');
      this.render(opts.render_args).done((function(_this) {
        return function() {
          var args;
          args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
          _this.init_events();
          _this.after_render([args]);
          opts.after_render.apply(_this, args);
          return _this.trigger('after_render', [args]);
        };
      })(this));
    }

    MuUI.prototype.render = function(data) {
      var $el, data_filter, datasource, def, opts, render_fn, render_tmpl, self, tmpl;
      self = this;
      $el = this.$el, opts = this.opts;
      if (!$html.has($el).length) {
        this.$el = $el = $(opts.el);
      }
      tmpl = opts.tmpl, render_fn = opts.render_fn, datasource = opts.datasource, data_filter = opts.data_filter;
      def = $.Deferred();
      render_tmpl = function(tmpl) {
        var render;
        render = function(data) {
          var $tmpl;
          $tmpl = $(tmpl(_.isEmpty(data) && {} || data));
          $el[render_fn]($tmpl);
          if (render_fn === 'replaceWith') {
            self.$el = $tmpl;
          }
          return def.resolve(data, $tmpl);
        };
        if (datasource) {
          return utils.api(datasource).done(function(data) {
            return render(data_filter(data));
          });
        } else {
          return render(_.isEmpty(data) && opts.data || data);
        }
      };
      if (tmpl) {
        if (utils.is_template(tmpl)) {
          render_tmpl(tmpl);
        } else {
          require(["text!" + tmpl + ".html"], function(tmpl) {
            return render_tmpl(_.template(tmpl));
          });
        }
      } else {
        def.resolve();
      }
      return def.promise();
    };

    MuUI.prototype.on = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      this._jq.on.apply(this._jq, args);
      return this;
    };

    MuUI.prototype.off = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      this._jq.off.apply(this._jq, args);
      return this;
    };

    MuUI.prototype.once = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      this._jq.one.apply(this._jq, args);
      return this;
    };

    MuUI.prototype.trigger = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      this._jq.trigger.apply(this._jq, args);
      return this;
    };


    /*
     * 以下方法暴露给子类覆盖
     */

    MuUI.prototype.init_events = function() {};

    MuUI.prototype.before_render = function() {};

    MuUI.prototype.after_render = function() {};

    return MuUI;

  })();
  return MuUI;
});
