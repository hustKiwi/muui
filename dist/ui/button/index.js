var extend=function(t,o){function n(){this.constructor=t}for(var e in o)hasProp.call(o,e)&&(t[e]=o[e]);return n.prototype=o.prototype,t.prototype=new n,t.__super__=o.prototype,t},hasProp={}.hasOwnProperty;define(["muui/core/base","muui/lib/bootstrap/button"],function(t){var o;return o=function(t){function o(){return o.__super__.constructor.apply(this,arguments)}return extend(o,t),o.defaults={el:".muui-btn",buttonOptions:{loadingText:"loading..."}},o.prototype.getOpts=function(t){return $.extend(!0,{},o.__super__.getOpts.call(this),o.defaults,t)},o.prototype.afterRender=function(){return this.$el.button(this.opts.tooltipOptions)},o}(t)});