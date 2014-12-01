var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define(['muui/core/base', 'muui/lib/bootstrap/js/button'], function(Base) {
  var Button;
  Button = (function(_super) {
    __extends(Button, _super);

    function Button() {
      return Button.__super__.constructor.apply(this, arguments);
    }

    Button.defaults = {
      el: '.muui-btn',
      button_options: {
        loadingText: 'loading...'
      }
    };

    Button.prototype.get_opts = function(options) {
      return $.extend(true, {}, Button.__super__.get_opts.call(this), Button.defaults, options);
    };

    Button.prototype.after_render = function() {
      return this.$el.button(this.opts.tooltip_options);
    };

    return Button;

  })(Base);
  return Button;
});
