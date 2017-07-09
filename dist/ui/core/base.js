var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty,
  slice = [].slice;

define(['muui/core/utils', 'muui/core/event_emitter'], function(utils, EventEmitter) {
  var MuUI;
  return MuUI = (function(superClass) {
    extend(MuUI, superClass);

    MuUI.defaults = {
      el: '',
      dataSource: '',
      renderArgs: {},
      renderFn: 'replaceWith',
      dataFilter: function(r) {
        return r;
      },
      beforeRender: function() {},
      afterRender: function() {},
      initEvents: function() {}
    };

    MuUI.prototype.getOpts = function() {
      return MuUI.defaults;
    };

    function MuUI(options) {
      var opts;
      this.opts = opts = this.getOpts(options);
      this.$el = $(opts.el).off();
      MuUI.__super__.constructor.call(this);
      this.beforeRender();
      opts.beforeRender.apply(this);
      this.trigger('beforeRender');
      this.render(opts.renderArgs).done((function(_this) {
        return function() {
          var args;
          args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
          _this.afterRender([args]);
          opts.afterRender.apply(_this, args);
          _this.trigger('afterRender', [args]).initEvents();
          return opts.initEvents.apply(_this);
        };
      })(this));
    }

    MuUI.prototype.render = function(renderArgs) {
      var $el, dataFilter, dataSource, def, opts, ref, ref1, renderFn, renderTmpl, self, tmpl;
      self = this;
      def = $.Deferred();
      ref = this, $el = ref.$el, opts = ref.opts, (ref1 = ref.opts, tmpl = ref1.tmpl, renderFn = ref1.renderFn, dataSource = ref1.dataSource, dataFilter = ref1.dataFilter);
      renderTmpl = function(tmpl) {
        var render;
        render = function(data) {
          var $tmpl;
          $tmpl = $(tmpl(_.isEmpty(data) && {} || data));
          $el[renderFn]($tmpl);
          if (renderFn === 'replaceWith') {
            self.$el = $tmpl;
          }
          return def.resolve(data, $tmpl);
        };
        if (dataSource) {
          return utils.api(dataSource).done(function(data) {
            return render(dataFilter(data));
          });
        } else {
          return render(renderArgs);
        }
      };
      if (tmpl) {
        renderTmpl(tmpl);
      } else {
        def.resolve();
      }
      return def.promise();
    };


    /*
     * 以下方法暴露给子类覆盖
     */

    MuUI.prototype.initEvents = function() {};

    MuUI.prototype.beforeRender = function() {};

    MuUI.prototype.afterRender = function() {};

    return MuUI;

  })(EventEmitter);
});
