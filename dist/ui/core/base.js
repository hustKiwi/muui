var slice=[].slice;define(["muui/core/utils"],function(e){var t;return t=function(){function t(e){var t;if(this._jq=$({}),this.opts=t=this.get_opts(e),!t.el)throw new Error("el cannot be empty.");this.$el=$(t.el),this.before_render(),t.before_render.apply(this),this.trigger("before_render"),this.render(t.render_args).done(function(e){return function(){var r;return r=1<=arguments.length?slice.call(arguments,0):[],e.after_render([r]),t.after_render.apply(e,r),e.trigger("after_render",[r]),e.init_events(),t.init_events.apply(e)}}(this))}return t.defaults={el:"",datasource:"",render_args:{},render_fn:"replaceWith",data_filter:function(e){return e},before_render:function(){},after_render:function(){},init_events:function(){}},t.prototype.get_opts=function(){return t.defaults},t.prototype.render=function(t){var r,n,i,o,s,a,u,l,p,f;return p=this,o=$.Deferred(),r=this.$el,s=this.opts,a=this.opts,f=a.tmpl,u=a.render_fn,i=a.datasource,n=a.data_filter,l=function(a){var l;return l=function(e){var t;return t=$(a(_.isEmpty(e)&&{}||e)),r[u](t),"replaceWith"===u&&(p.$el=t),o.resolve(e,t)},i?e.api(i).done(function(e){return l(n(e))}):l(_.isEmpty(t)&&s.data||t)},f?e.is_template(f)?l(f):require(["text!"+f+".html"],function(e){return l(_.template(e))}):o.resolve(),o.promise()},t.prototype.on=function(){var e;return e=1<=arguments.length?slice.call(arguments,0):[],this._jq.on.apply(this._jq,e),this},t.prototype.off=function(){var e;return e=1<=arguments.length?slice.call(arguments,0):[],this._jq.off.apply(this._jq,e),this},t.prototype.once=function(){var e;return e=1<=arguments.length?slice.call(arguments,0):[],this._jq.one.apply(this._jq,e),this},t.prototype.trigger=function(){var e;return e=1<=arguments.length?slice.call(arguments,0):[],this._jq.trigger.apply(this._jq,e),this},t.prototype.init_events=function(){},t.prototype.before_render=function(){},t.prototype.after_render=function(){},t}()});