var __hasProp={}.hasOwnProperty,__extends=function(t,e){function n(){this.constructor=t}for(var r in e)__hasProp.call(e,r)&&(t[r]=e[r]);return n.prototype=e.prototype,t.prototype=new n,t.__super__=e.prototype,t};define(["muui/core/base","muui/lib/tinycarousel/jquery.tinycarousel"],function(t){var e;return e=function(t){function e(){return e.__super__.constructor.apply(this,arguments)}return __extends(e,t),e.defaults={el:".muui-slider",item_cls:"muui-slider-item",buttons_tmpl:'<a href="#" class="arrow prev"></a>\n<a href="#" class="arrow next"></a>',bullets_tmpl:'<ol class="bullets">\n<% for (var i = 0; i < total; i++) { %>\n    <li class="bullet<%- i === cur ? \' active\': \'\' %>" data-slide="<%- i %>">\n        <%- i + 1 %>\n    </li>\n<% } %>\n</ol>',tinycarousel_options:{buttons:!0,bullets:!0,interval:!0,animationTime:300}},e.prototype.get_opts=function(t){return $.extend(!0,e.__super__.get_opts.call(this),e.defaults,t)},e.prototype.init_events=function(){var t,e;return e=this.$el,t=e.find(".arrow"),e.on("mouseenter",function(){return t.fadeIn()}).on("mouseleave",function(){return t.fadeOut()}),e.on("mouseenter",".arrow",function(){return $(this).addClass("on")}).on("mouseleave",".arrow",function(){return $(this).removeClass("on")})},e.prototype.before_render=function(){var t,e,n,r,o;return t=this.$el,n=this.opts,o=this.opts,r=o.tinycarousel_options,this.$items=e=t.find("."+n.item_cls),r.buttons&&t.append($(n.buttons_tmpl)),r.bullets?t.append($(_.template(n.bullets_tmpl,{cur:r.start,total:e.length}))):void 0},e.prototype.after_render=function(){return this.tinycarousel=this.$el.tinycarousel(this.opts.tinycarousel_options).data("plugin_tinycarousel")},e}(t)});