var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

define(['muui/core/base', 'muui/lib/bootstrap/tooltip', 'muui/lib/bootstrap/transition'], function(Base) {
  var Tooltip;
  return Tooltip = (function(superClass) {
    extend(Tooltip, superClass);

    function Tooltip() {
      return Tooltip.__super__.constructor.apply(this, arguments);
    }

    Tooltip.defaults = {
      el: '.muui-show-tooltip',
      tooltipOptions: {
        template: '<div class="muui-tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>'
      }
    };

    Tooltip.prototype.getOpts = function(options) {
      return $.extend(true, {}, Tooltip.__super__.getOpts.call(this), Tooltip.defaults, options);
    };

    Tooltip.prototype.beforeRender = function() {
      return this.$el.tooltip(this.opts.tooltipOptions);
    };

    Tooltip.prototype.show = function() {
      this.$el.tooltip('show');
      return this;
    };

    Tooltip.prototype.hide = function() {
      this.$el.tooltip('hide');
      return this;
    };

    Tooltip.prototype.toggle = function() {
      this.$el.tooltip('toggle');
      return this;
    };

    Tooltip.prototype.destroy = function() {
      this.$el.off().tooltip('destroy');
      return this;
    };

    return Tooltip;

  })(Base);
});
