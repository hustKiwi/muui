var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

define(['muui/core/base', 'muui/lib/bootstrap/button'], function(Base) {
  var Button;
  return Button = (function(superClass) {
    extend(Button, superClass);

    function Button() {
      return Button.__super__.constructor.apply(this, arguments);
    }

    Button.defaults = {
      el: '.muui-btn',
      buttonOptions: {
        loadingText: 'loading...'
      }
    };

    Button.prototype.getOpts = function(options) {
      return $.extend(true, {}, Button.__super__.getOpts.call(this), Button.defaults, options);
    };

    Button.prototype.afterRender = function() {
      return this.$el.button(this.opts.tooltipOptions);
    };

    return Button;

  })(Base);
});
