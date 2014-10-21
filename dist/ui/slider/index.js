define("core/utils",[],function(){var t;return t=String.prototype,_.isFunction(t.startsWith)||(t.startsWith=function(t){return this.slice(0,t.length)===t}),_.isFunction(t.endsWith)||(t.endsWith=function(t){return this.slice(-t.length)===t}),{api:function(t,e,n){var r,i,o;return r=$.Deferred(),i={type:"GET",dataType:"jsonp",handleError:function(t){return"undefined"!=typeof console&&null!==console&&"function"==typeof console.error?console.error(t):void 0}},_.isObject(t)&&(n=e,e=t.data,t=t.url),o=$.extend(i,n),null==e&&(e={}),$.ajax({url:t,data:e,dataType:o.dataType,type:o.type,success:function(t){return r.resolve(t)},error:function(){return r.reject(),o.handleError("ajax error")}}),r.promise()},is_template:function(t){return _.isFunction(t)&&"source"in t},is_ie6:function(){return"undefined"==typeof document.body.style.maxHeight}}});var __slice=[].slice;define("core/muui",["core/utils"],function(t){var e,n;return e=$("html"),n=function(){function n(t){var e;if(this._jq=$({}),this.opts=e=this.get_opts(t),!e.el)throw new Error("el cannot be empty.");this.$el=$(e.el),this.before_render(),e.before_render(),this.trigger("before_render"),this.render(e.render_args).done(function(t){return function(){var n;return n=1<=arguments.length?__slice.call(arguments,0):[],t.init_events(),t.after_render([n]),e.after_render([n]),t.trigger("after_render",[n])}}(this))}return n.defaults={el:"",datasource:"",render_args:{},render_fn:"replaceWith",data_filter:function(t){return t},before_render:function(){},after_render:function(){}},n.prototype.get_opts=function(){return n.defaults},n.prototype.render=function(n){var r,i,o,s,u,l,a,c,f;return c=this,r=this.$el,u=this.opts,e.has(r).length||(this.$el=r=$(u.el)),f=u.tmpl,l=u.render_fn,o=u.datasource,i=u.data_filter,s=$.Deferred(),a=function(e){var a;return a=function(t){var n;return n=$(e(_.isEmpty(t)&&{}||t)),r[l](n),"replaceWith"===l&&(c.$el=n),s.resolve(t,n)},o?t.api(o).done(function(t){return a(i(t))}):a(_.isEmpty(n)&&u.data||n)},f?t.is_template(f)?a(f):require(["text!"+f+".html"],function(t){return a(_.template(t))}):s.resolve(),s.promise()},n.prototype.on=function(){var t;return t=1<=arguments.length?__slice.call(arguments,0):[],this._jq.on.apply(this._jq,t),this},n.prototype.off=function(){var t;return t=1<=arguments.length?__slice.call(arguments,0):[],this._jq.off.apply(this._jq,t),this},n.prototype.once=function(){var t;return t=1<=arguments.length?__slice.call(arguments,0):[],this._jq.one.apply(this._jq,t),this},n.prototype.trigger=function(){var t;return t=1<=arguments.length?__slice.call(arguments,0):[],this._jq.trigger.apply(this._jq,t),this},n.prototype.init_events=function(){},n.prototype.before_render=function(){},n.prototype.after_render=function(){},n}()}),function(t){"function"==typeof define&&define.amd?define("bower/tinycarousel/lib/jquery.tinycarousel",["jquery"],t):t("object"==typeof exports?require("jquery"):jQuery)}(function(t){function e(e,i){function o(){return l.update(),l.move(l.slideCurrent),s(),l}function s(){l.options.buttons&&(d.click(function(){return l.move(--g),!1}),p.click(function(){return l.move(++g),!1})),t(window).resize(l.update),l.options.bullets&&e.on("click",".bullet",function(){return l.move(g=+t(this).attr("data-slide")),!1})}function u(){l.options.buttons&&!l.options.infinite&&(d.toggleClass("disable",l.slideCurrent<=0),p.toggleClass("disable",l.slideCurrent>=l.slidesTotal-y)),l.options.bullets&&(_.removeClass("active"),t(_[l.slideCurrent]).addClass("active"))}this.options=t.extend({},r,i),this._defaults=r,this._name=n;var l=this,a=e.find(".viewport:first"),c=e.find(".overview:first"),f=0,p=e.find(".next:first"),d=e.find(".prev:first"),_=e.find(".bullet"),h=0,m={},y=0,v=0,g=0,b="x"===this.options.axis,$=b?"Width":"Height",j=b?"left":"top",T=null;return this.slideCurrent=0,this.slidesTotal=0,this.update=function(){return c.find(".mirrored").remove(),f=c.children(),h=a[0]["offset"+$],v=f.first()["outer"+$](!0),l.slidesTotal=f.length,l.slideCurrent=l.options.start||0,y=Math.ceil(h/v),c.append(f.slice(0,y).clone().addClass("mirrored")),c.css($.toLowerCase(),v*(l.slidesTotal+y)),l},this.start=function(){return l.options.interval&&(clearTimeout(T),T=setTimeout(function(){l.move(++g)},l.options.intervalTime)),l},this.stop=function(){return clearTimeout(T),l},this.move=function(t){return g=t,l.slideCurrent=g%l.slidesTotal,0>g&&(l.slideCurrent=g=l.slidesTotal-1,c.css(j,-l.slidesTotal*v)),g>l.slidesTotal&&(l.slideCurrent=g=1,c.css(j,0)),m[j]=-g*v,c.animate(m,{queue:!1,duration:l.options.animation?l.options.animationTime:0,always:function(){e.trigger("move",[f[l.slideCurrent],l.slideCurrent])}}),u(),l.start(),l},o()}var n="tinycarousel",r={start:0,axis:"x",buttons:!0,bullets:!1,interval:!1,intervalTime:3e3,animation:!0,animationTime:1e3,infinite:!0};t.fn[n]=function(r){return this.each(function(){t.data(this,"plugin_"+n)||t.data(this,"plugin_"+n,new e(t(this),r))})}});var __hasProp={}.hasOwnProperty,__extends=function(t,e){function n(){this.constructor=t}for(var r in e)__hasProp.call(e,r)&&(t[r]=e[r]);return n.prototype=e.prototype,t.prototype=new n,t.__super__=e.prototype,t};define("muui/slider/index",["core/muui","bower/tinycarousel/lib/jquery.tinycarousel"],function(t){var e;return e=function(t){function e(){return e.__super__.constructor.apply(this,arguments)}return __extends(e,t),e.defaults={el:".muui-slider",item_cls:"muui-slider-item",buttons_tmpl:'<ul class="buttons">\n    <li class="arrow prev"></li>\n    <li class="arrow next"></li>\n</ul>',bullets_tmpl:'<ol class="bullets">\n<% for (var i = 0; i < total; i++) { %>\n    <li class="bullet<%- i === cur ? \' active\': \'\' %>" data-slide="<%- i %>">\n        <%- i + 1 %>\n    </li>\n<% } %>\n</ol>',tinycarousel_options:{buttons:!0,bullets:!0,interval:!1,animationTime:300}},e.prototype.get_opts=function(t){return $.extend(!0,{},e.__super__.get_opts.call(this),e.defaults,t)},e.prototype.init_events=function(){var t,e;return e=this.$el,t=e.find(".buttons"),e.on("mouseenter",function(){return t.fadeIn()}).on("mouseleave",function(){return t.fadeOut()}),t.on("mouseenter",".arrow",function(){return $(this).addClass("on")}).on("mouseleave",".arrow",function(){return $(this).removeClass("on")})},e.prototype.before_render=function(){var t,e,n,r,i;return t=this.$el,n=this.opts,i=this.opts,r=i.tinycarousel_options,this.$items=e=t.find("."+n.item_cls),r.buttons&&t.append($(n.buttons_tmpl)),r.bullets?t.append($(_.template(n.bullets_tmpl,{cur:r.start,total:e.length}))):void 0},e.prototype.after_render=function(){return this.tinycarousel=this.$el.tinycarousel(this.opts.tinycarousel_options).data("plugin_tinycarousel")},e}(t)});