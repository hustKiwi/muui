var __hasProp={}.hasOwnProperty,__extends=function(t,o){function e(){this.constructor=t}for(var r in o)__hasProp.call(o,r)&&(t[r]=o[r]);return e.prototype=o.prototype,t.prototype=new e,t.__super__=o.prototype,t};define(["muui/core/base","muui/lib/bootstrap/tooltip"],function(t){var o;return o=function(t){function o(){return o.__super__.constructor.apply(this,arguments)}return __extends(o,t),o.defaults={el:".muui-show-tooltip",tooltip_options:{template:'<div class="muui-tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>'}},o.prototype.get_opts=function(t){return $.extend(!0,{},o.__super__.get_opts.call(this),o.defaults,t)},o.prototype.after_render=function(){var t;return this.tooltip=t=this.$el.tooltip(this.opts.tooltip_options).data("bs.tooltip"),this.$tip=t.tip()},o.prototype.show=function(){return this.$el.modal("show")},o.prototype.hide=function(){return this.$el.modal("hide")},o.prototype.toggle=function(){return this.$el.modal("toggle")},o.prototype.destroy=function(){return this.$el.modal("destroy")},o}(t)});