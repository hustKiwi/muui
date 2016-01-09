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
      itemCls: 'muui-tab-item',
      handles: {
        change: function($item, $target) {}
      }
    };

    Tab.prototype.getOpts = function(options) {
      return $.extend(true, {}, Tab.__super__.getOpts.call(this), Tab.defaults, options);
    };

    Tab.prototype.initEvents = function() {
      var handles, itemCls, ref, self;
      self = this;
      ref = this.opts, itemCls = ref.itemCls, handles = ref.handles;
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
        self.trigger('change', $this, $target);
        return false;
      });
    };

    return Tab;

  })(Base);
});
