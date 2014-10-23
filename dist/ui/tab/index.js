define("muui/core/utils",[],function(){var e;return e=String.prototype,_.isFunction(e.startsWith)||(e.startsWith=function(e){return this.slice(0,e.length)===e}),_.isFunction(e.endsWith)||(e.endsWith=function(e){return this.slice(-e.length)===e}),{api:function(e,t,r){var n,o,i;return n=$.Deferred(),o={type:"GET",dataType:"jsonp",handleError:function(e){return"undefined"!=typeof console&&null!==console&&"function"==typeof console.error?console.error(e):void 0}},_.isObject(e)&&(r=t,t=e.data,e=e.url),i=$.extend(o,r),null==t&&(t={}),$.ajax({url:e,data:t,dataType:i.dataType,type:i.type,success:function(e){return n.resolve(e)},error:function(){return n.reject(),i.handleError("ajax error")}}),n.promise()},is_template:function(e){return _.isFunction(e)&&"source"in e},is_ie6:function(){return"undefined"==typeof document.body.style.maxHeight}}});var __slice=[].slice;define("muui/core/base",["muui/core/utils"],function(e){var t,r;return t=$("html"),r=function(){function r(e){var t;if(this._jq=$({}),this.opts=t=this.get_opts(e),!t.el)throw new Error("el cannot be empty.");this.$el=$(t.el),this.before_render(),t.before_render(),this.trigger("before_render"),this.render(t.render_args).done(function(e){return function(){var r;return r=1<=arguments.length?__slice.call(arguments,0):[],e.init_events(),e.after_render([r]),t.after_render([r]),e.trigger("after_render",[r])}}(this))}return r.defaults={el:"",datasource:"",render_args:{},render_fn:"replaceWith",data_filter:function(e){return e},before_render:function(){},after_render:function(){}},r.prototype.get_opts=function(){return r.defaults},r.prototype.render=function(r){var n,o,i,s,u,a,l,c,p;return c=this,n=this.$el,u=this.opts,t.has(n).length||(this.$el=n=$(u.el)),p=u.tmpl,a=u.render_fn,i=u.datasource,o=u.data_filter,s=$.Deferred(),l=function(t){var l;return l=function(e){var r;return r=$(t(_.isEmpty(e)&&{}||e)),n[a](r),"replaceWith"===a&&(c.$el=r),s.resolve(e,r)},i?e.api(i).done(function(e){return l(o(e))}):l(_.isEmpty(r)&&u.data||r)},p?e.is_template(p)?l(p):require(["text!"+p+".html"],function(e){return l(_.template(e))}):s.resolve(),s.promise()},r.prototype.on=function(){var e;return e=1<=arguments.length?__slice.call(arguments,0):[],this._jq.on.apply(this._jq,e),this},r.prototype.off=function(){var e;return e=1<=arguments.length?__slice.call(arguments,0):[],this._jq.off.apply(this._jq,e),this},r.prototype.once=function(){var e;return e=1<=arguments.length?__slice.call(arguments,0):[],this._jq.one.apply(this._jq,e),this},r.prototype.trigger=function(){var e;return e=1<=arguments.length?__slice.call(arguments,0):[],this._jq.trigger.apply(this._jq,e),this},r.prototype.init_events=function(){},r.prototype.before_render=function(){},r.prototype.after_render=function(){},r}()});var __hasProp={}.hasOwnProperty,__extends=function(e,t){function r(){this.constructor=e}for(var n in t)__hasProp.call(t,n)&&(e[n]=t[n]);return r.prototype=t.prototype,e.prototype=new r,e.__super__=t.prototype,e};define("muui/tab/index",["muui/core/base"],function(e){var t;return t=function(e){function t(){return t.__super__.constructor.apply(this,arguments)}return __extends(t,e),t.defaults={el:".muui-tab",tmpl:"muui/tab/index",handles:{change:function(){}}},t.prototype.get_opts=function(e){return $.extend(!0,{},t.__super__.get_opts.call(this),t.defaults,e)},t.prototype.init_events=function(){var e,t;return t="muui-tab-item",e=this.opts.handles,this.$el.on("mouseenter","."+t+":not(.on)",function(){return $(this).addClass("hover")}).on("mouseleave","."+t+":not(.on)",function(){return $(this).removeClass("hover")}).on("click","."+t+":not(.on)",function(){var t,r;return r=$(this),t=$(r.data("target")),r.siblings(".on").removeClass("on").end().removeClass("hover").addClass("on"),t.siblings(".on").removeClass("on").end().addClass("on"),e.change(r,t),!1})},t}(e)});