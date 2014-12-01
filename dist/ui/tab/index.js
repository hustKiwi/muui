var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define(['muui/core/base'], function(Base) {
  var Tab;
  Tab = (function(_super) {
    __extends(Tab, _super);

    function Tab() {
      return Tab.__super__.constructor.apply(this, arguments);
    }

    Tab.defaults = {
      el: '.muui-tab',
      tmpl: 'muui/tab/index',
      handles: {
        change: function($item, $target) {}
      }
    };

    Tab.prototype.get_opts = function(options) {
      return $.extend(true, {}, Tab.__super__.get_opts.call(this), Tab.defaults, options);
    };

    Tab.prototype.init_events = function() {
      var handles, item_cls;
      item_cls = 'muui-tab-item';
      handles = this.opts.handles;
      return this.$el.on('mouseenter', "." + item_cls + ":not(.on)", function() {
        return $(this).addClass('hover');
      }).on('mouseleave', "." + item_cls + ":not(.on)", function() {
        return $(this).removeClass('hover');
      }).on('click', "." + item_cls + ":not(.on)", function() {
        var $target, $this;
        $this = $(this);
        $target = $($this.data('target'));
        $this.siblings('.on').removeClass('on').end().removeClass('hover').addClass('on');
        $target.siblings('.on').removeClass('on').end().addClass('on');
        handles.change($this, $target);
        return false;
      });
    };

    return Tab;

  })(Base);
  return Tab;
});
