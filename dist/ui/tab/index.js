var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

define(['muui/core/base'], function(Base) {
  var Tab;
  return Tab = (function(superClass) {
    extend(Tab, superClass);

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

    Tab.prototype.getOpts = function(options) {
      return $.extend(true, {}, Tab.__super__.getOpts.call(this), Tab.defaults, options);
    };

    Tab.prototype.initEvents = function() {
      var handles, itemCls;
      itemCls = 'muui-tab-item';
      handles = this.opts.handles;
      return this.$el.on('mouseenter', "." + itemCls + ":not(.on)", function() {
        return $(this).addClass('hover');
      }).on('mouseleave', "." + itemCls + ":not(.on)", function() {
        return $(this).removeClass('hover');
      }).on('click', "." + itemCls + ":not(.on)", function() {
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
});
