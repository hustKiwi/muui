var extend=function(t,n){function e(){this.constructor=t}for(var o in n)hasProp.call(n,o)&&(t[o]=n[o]);return e.prototype=n.prototype,t.prototype=new e,t.__super__=n.prototype,t},hasProp={}.hasOwnProperty;define(["muui/core/base"],function(t){var n;return n=function(t){function n(){return n.__super__.constructor.apply(this,arguments)}return extend(n,t),n.defaults={el:".muui-tab",tmpl:"muui/tab/index",handles:{change:function(t,n){}}},n.prototype.getOpts=function(t){return $.extend(!0,{},n.__super__.getOpts.call(this),n.defaults,t)},n.prototype.initEvents=function(){var t,n;return n="muui-tab-item",t=this.opts.handles,this.$el.on("mouseenter","."+n+":not(.on)",function(){return $(this).addClass("hover")}).on("mouseleave","."+n+":not(.on)",function(){return $(this).removeClass("hover")}).on("click","."+n+":not(.on)",function(){var n,e;return e=$(this),n=$(e.data("target")),e.siblings(".on").removeClass("on").end().removeClass("hover").addClass("on"),n.siblings(".on").removeClass("on").end().addClass("on"),t.change(e,n),!1})},n}(t)});