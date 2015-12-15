var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

define(['muui/core/base', 'muui/lib/tinycarousel/jquery.tinycarousel'], function(Base) {
  var Slider;
  return Slider = (function(superClass) {
    extend(Slider, superClass);

    function Slider() {
      return Slider.__super__.constructor.apply(this, arguments);
    }

    Slider.defaults = {
      el: '.muui-slider',
      itemCls: 'muui-slider-item',
      buttonsTmpl: '<a href="#" class="arrow prev"></a>\n<a href="#" class="arrow next"></a>',
      bulletsTmpl: '<ol class="bullets">\n<% for (var i = 0; i < total; i++) { %>\n    <li class="bullet<%- i === cur ? \' active\': \'\' %>" data-slide="<%- i %>">\n        <%- i + 1 %>\n    </li>\n<% } %>\n</ol>',
      tinycarouselOptions: {
        buttons: true,
        bullets: true,
        interval: true,
        animationTime: 500
      }
    };

    Slider.prototype.getOpts = function(options) {
      return $.extend(true, {}, Slider.__super__.getOpts.call(this), Slider.defaults, options);
    };

    Slider.prototype.initEvents = function() {
      var $arrow, $el, tinycarousel;
      $el = this.$el, tinycarousel = this.tinycarousel;
      $arrow = $el.find('.arrow');
      $el.on('mouseenter', function() {
        $arrow.fadeIn();
        return tinycarousel.stop();
      }).on('mouseleave', function() {
        $arrow.fadeOut();
        return tinycarousel.start();
      });
      return $el.on('mouseenter', '.arrow', function() {
        return $(this).addClass('on');
      }).on('mouseleave', '.arrow', function() {
        return $(this).removeClass('on');
      });
    };

    Slider.prototype.beforeRender = function() {
      var $el, $items, opts, ref, tinycarouselOptions;
      $el = this.$el, opts = this.opts, (ref = this.opts, tinycarouselOptions = ref.tinycarouselOptions);
      this.$items = $items = $el.find('.' + opts.itemCls);
      if (tinycarouselOptions.buttons) {
        $el.append($(opts.buttonsTmpl));
      }
      if (tinycarouselOptions.bullets) {
        return $el.append($(_.template(opts.bulletsTmpl)({
          cur: tinycarouselOptions.start,
          total: $items.length
        })));
      }
    };

    Slider.prototype.afterRender = function() {
      return this.tinycarousel = this.$el.tinycarousel(this.opts.tinycarouselOptions).data('plugin_tinycarousel');
    };

    return Slider;

  })(Base);
});
