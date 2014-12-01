var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define(['muui/core/base', 'muui/lib/bootstrap/js/tooltip'], function(Base) {
  var Tooltip;
  Tooltip = (function(_super) {
    __extends(Tooltip, _super);

    function Tooltip() {
      return Tooltip.__super__.constructor.apply(this, arguments);
    }

    Tooltip.defaults = {
      tooltip_options: {
        template: '<div class="muui-tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>'
      }
    };

    Tooltip.prototype.get_opts = function(options) {
      return $.extend(true, {}, Tooltip.__super__.get_opts.call(this), Tooltip.defaults, options);
    };

    Tooltip.prototype.after_render = function() {
      return this.tooltip = this.$el.tooltip(this.opts.tooltip_options).data('bs.tooltip');
    };

    Tooltip.prototype.show = function() {
      return this.$el.modal('show');
    };

    Tooltip.prototype.hide = function() {
      return this.$el.modal('hide');
    };

    Tooltip.prototype.toggle = function() {
      return this.$el.modal('toggle');
    };

    Tooltip.prototype.destroy = function() {
      return this.$el.modal('destroy');
    };

    return Tooltip;

  })(Base);
  return Tooltip;
});
