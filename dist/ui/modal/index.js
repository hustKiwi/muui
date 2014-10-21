/* ========================================================================
 * Bootstrap: modal.js v3.2.0
 * http://getbootstrap.com/javascript/#modals
 * ========================================================================
 * Copyright 2011-2014 Twitter, Inc.
 * Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
 * ======================================================================== */

/* ========================================================================
 * Bootstrap: transition.js v3.2.0
 * http://getbootstrap.com/javascript/#transitions
 * ========================================================================
 * Copyright 2011-2014 Twitter, Inc.
 * Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
 * ======================================================================== */

define("core/utils",[],function(){var t;return t=String.prototype,_.isFunction(t.startsWith)||(t.startsWith=function(t){return this.slice(0,t.length)===t}),_.isFunction(t.endsWith)||(t.endsWith=function(t){return this.slice(-t.length)===t}),{api:function(t,e,n){var o,i,r;return o=$.Deferred(),i={type:"GET",dataType:"jsonp",handleError:function(t){return"undefined"!=typeof console&&null!==console&&"function"==typeof console.error?console.error(t):void 0}},_.isObject(t)&&(n=e,e=t.data,t=t.url),r=$.extend(i,n),null==e&&(e={}),$.ajax({url:t,data:e,dataType:r.dataType,type:r.type,success:function(t){return o.resolve(t)},error:function(){return o.reject(),r.handleError("ajax error")}}),o.promise()},is_template:function(t){return _.isFunction(t)&&"source"in t},is_ie6:function(){return"undefined"==typeof document.body.style.maxHeight}}});var __slice=[].slice;define("core/muui",["core/utils"],function(t){var e,n;return e=$("html"),n=function(){function n(t){var e;if(this._jq=$({}),this.opts=e=this.get_opts(t),!e.el)throw new Error("el cannot be empty.");this.$el=$(e.el),this.before_render(),e.before_render(),this.trigger("before_render"),this.render(e.render_args).done(function(t){return function(){var n;return n=1<=arguments.length?__slice.call(arguments,0):[],t.init_events(),t.after_render([n]),e.after_render([n]),t.trigger("after_render",[n])}}(this))}return n.defaults={el:"",datasource:"",render_args:{},render_fn:"replaceWith",data_filter:function(t){return t},before_render:function(){},after_render:function(){}},n.prototype.get_opts=function(){return n.defaults},n.prototype.render=function(n){var o,i,r,s,a,d,l,u,c;return u=this,o=this.$el,a=this.opts,e.has(o).length||(this.$el=o=$(a.el)),c=a.tmpl,d=a.render_fn,r=a.datasource,i=a.data_filter,s=$.Deferred(),l=function(e){var l;return l=function(t){var n;return n=$(e(_.isEmpty(t)&&{}||t)),o[d](n),"replaceWith"===d&&(u.$el=n),s.resolve(t,n)},r?t.api(r).done(function(t){return l(i(t))}):l(_.isEmpty(n)&&a.data||n)},c?t.is_template(c)?l(c):require(["text!"+c+".html"],function(t){return l(_.template(t))}):s.resolve(),s.promise()},n.prototype.on=function(){var t;return t=1<=arguments.length?__slice.call(arguments,0):[],this._jq.on.apply(this._jq,t),this},n.prototype.off=function(){var t;return t=1<=arguments.length?__slice.call(arguments,0):[],this._jq.off.apply(this._jq,t),this},n.prototype.once=function(){var t;return t=1<=arguments.length?__slice.call(arguments,0):[],this._jq.one.apply(this._jq,t),this},n.prototype.trigger=function(){var t;return t=1<=arguments.length?__slice.call(arguments,0):[],this._jq.trigger.apply(this._jq,t),this},n.prototype.init_events=function(){},n.prototype.before_render=function(){},n.prototype.after_render=function(){},n}()}),+function(t){function e(e,o){return this.each(function(){var i=t(this),r=i.data("bs.modal"),s=t.extend({},n.DEFAULTS,i.data(),"object"==typeof e&&e);r||i.data("bs.modal",r=new n(this,s)),"string"==typeof e?r[e](o):s.show&&r.show(o)})}var n=function(e,n){this.options=n,this.$body=t(document.body),this.$element=t(e),this.$backdrop=this.isShown=null,this.scrollbarWidth=0,this.options.remote&&this.$element.find(".modal-content").load(this.options.remote,t.proxy(function(){this.$element.trigger("loaded.bs.modal")},this))};n.VERSION="3.2.0",n.DEFAULTS={backdrop:!0,keyboard:!0,show:!0},n.prototype.toggle=function(t){return this.isShown?this.hide():this.show(t)},n.prototype.show=function(e){var n=this,o=t.Event("show.bs.modal",{relatedTarget:e});this.$element.trigger(o),this.isShown||o.isDefaultPrevented()||(this.isShown=!0,this.checkScrollbar(),this.$body.addClass("modal-open"),this.setScrollbar(),this.escape(),this.$element.on("click.dismiss.bs.modal",'[data-dismiss="modal"]',t.proxy(this.hide,this)),this.backdrop(function(){var o=t.support.transition&&n.$element.hasClass("fade");n.$element.parent().length||n.$element.appendTo(n.$body),n.$element.show().scrollTop(0),o&&n.$element[0].offsetWidth,n.$element.addClass("in").attr("aria-hidden",!1),n.enforceFocus();var i=t.Event("shown.bs.modal",{relatedTarget:e});o?n.$element.find(".modal-dialog").one("bsTransitionEnd",function(){n.$element.trigger("focus").trigger(i)}).emulateTransitionEnd(300):n.$element.trigger("focus").trigger(i)}))},n.prototype.hide=function(e){e&&e.preventDefault(),e=t.Event("hide.bs.modal"),this.$element.trigger(e),this.isShown&&!e.isDefaultPrevented()&&(this.isShown=!1,this.$body.removeClass("modal-open"),this.resetScrollbar(),this.escape(),t(document).off("focusin.bs.modal"),this.$element.removeClass("in").attr("aria-hidden",!0).off("click.dismiss.bs.modal"),t.support.transition&&this.$element.hasClass("fade")?this.$element.one("bsTransitionEnd",t.proxy(this.hideModal,this)).emulateTransitionEnd(300):this.hideModal())},n.prototype.enforceFocus=function(){t(document).off("focusin.bs.modal").on("focusin.bs.modal",t.proxy(function(t){this.$element[0]===t.target||this.$element.has(t.target).length||this.$element.trigger("focus")},this))},n.prototype.escape=function(){this.isShown&&this.options.keyboard?this.$element.on("keyup.dismiss.bs.modal",t.proxy(function(t){27==t.which&&this.hide()},this)):this.isShown||this.$element.off("keyup.dismiss.bs.modal")},n.prototype.hideModal=function(){var t=this;this.$element.hide(),this.backdrop(function(){t.$element.trigger("hidden.bs.modal")})},n.prototype.removeBackdrop=function(){this.$backdrop&&this.$backdrop.remove(),this.$backdrop=null},n.prototype.backdrop=function(e){var n=this,o=this.$element.hasClass("fade")?"fade":"";if(this.isShown&&this.options.backdrop){var i=t.support.transition&&o;if(this.$backdrop=t('<div class="modal-backdrop '+o+'" />').appendTo(this.$body),this.$element.on("click.dismiss.bs.modal",t.proxy(function(t){t.target===t.currentTarget&&("static"==this.options.backdrop?this.$element[0].focus.call(this.$element[0]):this.hide.call(this))},this)),i&&this.$backdrop[0].offsetWidth,this.$backdrop.addClass("in"),!e)return;i?this.$backdrop.one("bsTransitionEnd",e).emulateTransitionEnd(150):e()}else if(!this.isShown&&this.$backdrop){this.$backdrop.removeClass("in");var r=function(){n.removeBackdrop(),e&&e()};t.support.transition&&this.$element.hasClass("fade")?this.$backdrop.one("bsTransitionEnd",r).emulateTransitionEnd(150):r()}else e&&e()},n.prototype.checkScrollbar=function(){document.body.clientWidth>=window.innerWidth||(this.scrollbarWidth=this.scrollbarWidth||this.measureScrollbar())},n.prototype.setScrollbar=function(){var t=parseInt(this.$body.css("padding-right")||0,10);this.scrollbarWidth&&this.$body.css("padding-right",t+this.scrollbarWidth)},n.prototype.resetScrollbar=function(){this.$body.css("padding-right","")},n.prototype.measureScrollbar=function(){var t=document.createElement("div");t.className="modal-scrollbar-measure",this.$body.append(t);var e=t.offsetWidth-t.clientWidth;return this.$body[0].removeChild(t),e};var o=t.fn.modal;t.fn.modal=e,t.fn.modal.Constructor=n,t.fn.modal.noConflict=function(){return t.fn.modal=o,this},t(document).on("click.bs.modal.data-api",'[data-toggle="modal"]',function(n){var o=t(this),i=o.attr("href"),r=t(o.attr("data-target")||i&&i.replace(/.*(?=#[^\s]+$)/,"")),s=r.data("bs.modal")?"toggle":t.extend({remote:!/#/.test(i)&&i},r.data(),o.data());o.is("a")&&n.preventDefault(),r.one("show.bs.modal",function(t){t.isDefaultPrevented()||r.one("hidden.bs.modal",function(){o.is(":visible")&&o.trigger("focus")})}),e.call(r,s,this)})}(jQuery),define("bootstrap/modal",function(){}),+function(t){function e(){var t=document.createElement("bootstrap"),e={WebkitTransition:"webkitTransitionEnd",MozTransition:"transitionend",OTransition:"oTransitionEnd otransitionend",transition:"transitionend"};for(var n in e)if(void 0!==t.style[n])return{end:e[n]};return!1}t.fn.emulateTransitionEnd=function(e){var n=!1,o=this;t(this).one("bsTransitionEnd",function(){n=!0});var i=function(){n||t(o).trigger(t.support.transition.end)};return setTimeout(i,e),this},t(function(){t.support.transition=e(),t.support.transition&&(t.event.special.bsTransitionEnd={bindType:t.support.transition.end,delegateType:t.support.transition.end,handle:function(e){return t(e.target).is(this)?e.handleObj.handler.apply(this,arguments):void 0}})})}(jQuery),define("bootstrap/transition",function(){});var __hasProp={}.hasOwnProperty,__extends=function(t,e){function n(){this.constructor=t}for(var o in e)__hasProp.call(e,o)&&(t[o]=e[o]);return n.prototype=e.prototype,t.prototype=new n,t.__super__=e.prototype,t};define("muui/modal/index",["core/muui","core/utils","bootstrap/modal","bootstrap/transition"],function(t,e){var n,o,i;return o=$(window),n=$(document),i=function(t){function o(){return o.__super__.constructor.apply(this,arguments)}return __extends(o,t),o.defaults={el:".muui-modal",container:'<div class="muui-modal fade"></div>',tmpl:_.template('<div class="muui-modal-dialog modal-dialog">\n    <div class="muui-modal-header">\n        <% if (title) { %>\n            <h3><%= title %></h3>\n        <% } %>\n        <% if (btns.close) { %>\n            <span class="close" data-dismiss="modal" aria-hidden="true">×</span>\n        <% } %>\n    </div>\n    <div class="muui-modal-body"><%= body %></div>\n    <div class="muui-modal-footer">\n        <% if (btns.submit) { %>\n            <button class="muui-btn muui-btn-primary submit" data-dismiss="modal" aria-hidden="true">提交\n        <% } %>\n        <% if (btns.cancel) { %>\n            <button class="muui-btn" data-dismiss="modal" aria-hidden="true">取消</button>\n        <% } %>\n        <%= footer %>\n    </div>\n</div>'),data:{title:"",btns:{close:!0,submit:!0,cancel:!0},body:"",footer:""},render_fn:"html",offset_top:-120,offset_left:0,modal_options:{backdrop:"static"}},o.prototype.get_opts=function(t){return $.extend(!0,{},o.__super__.get_opts.call(this),o.defaults,t)},o.prototype.init_events=function(){var t;return t=this.$el,t.on("show.bs.modal",function(o){return function(){return t.css({marginTop:o._calc_top()+(e.is_ie6()&&n.scrollTop()||0),marginLeft:o._calc_left()})}}(this))},o.prototype.before_render=function(){return this.$el.length?void 0:this.$el=$(this.opts.container).appendTo("body")},o.prototype.after_render=function(){return this.modal=this.$el.modal(this.opts.modal_options).data("bs.modal"),this.modal.$backdrop.addClass("muui-modal-backdrop")},o.prototype.show=function(){return this.$el.modal("show")},o.prototype.hide=function(){return this.$el.modal("hide")},o.prototype.toggle=function(){return this.$el.modal("toggle")},o.prototype._calc_top=function(){var t;return t=this.opts.offset_top,_.isFunction(t)&&(t=t.call(this)),-(this.$el.height()/2-(t||0))},o.prototype._calc_left=function(){var t;return t=this.opts.offset_left,_.isFunction(t)&&(t=t.call(this)),-(this.$el.width()/2-(t||0))},o}(t)});