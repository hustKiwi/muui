var __hasProp={}.hasOwnProperty,__extends=function(t,o){function n(){this.constructor=t}for(var i in o)__hasProp.call(o,i)&&(t[i]=o[i]);return n.prototype=o.prototype,t.prototype=new n,t.__super__=o.prototype,t};define(["muui/core/base","muui/core/utils","muui/lib/bootstrap/modal","muui/lib/bootstrap/transition"],function(t,o){var n,i,e;return i=$(window),n=$(document),e=function(t){function i(){return i.__super__.constructor.apply(this,arguments)}return __extends(i,t),i.defaults={el:".muui-modal",container:'<div class="muui-modal fade"></div>',tmpl:_.template('<div class="muui-modal-dialog modal-dialog">\n    <div class="muui-modal-header">\n        <% if (title) { %>\n            <h3><%= title %></h3>\n        <% } %>\n        <% if (btns.close) { %>\n            <span class="close" data-dismiss="modal" aria-hidden="true">×</span>\n        <% } %>\n    </div>\n    <div class="muui-modal-body"><%= body %></div>\n    <div class="muui-modal-footer">\n        <% if (btns.submit) { %>\n            <button class="muui-btn muui-btn-primary submit" data-dismiss="modal" aria-hidden="true">提交\n        <% } %>\n        <% if (btns.cancel) { %>\n            <button class="muui-btn" data-dismiss="modal" aria-hidden="true">取消</button>\n        <% } %>\n        <%= footer %>\n    </div>\n</div>'),data:{title:"",btns:{close:!0,submit:!0,cancel:!0},body:"",footer:""},render_fn:"html",offset_top:-120,offset_left:0,modal_options:{backdrop:"static"}},i.prototype.get_opts=function(t){return $.extend(!0,{},i.__super__.get_opts.call(this),i.defaults,t)},i.prototype.init_events=function(){var t;return t=this.$el,t.on("show.bs.modal",function(i){return function(){return t.css({marginTop:i._calc_top()+(o.is_ie6()&&n.scrollTop()||0),marginLeft:i._calc_left()})}}(this))},i.prototype.before_render=function(){return this.$el.length?void 0:this.$el=$(this.opts.container).appendTo("body")},i.prototype.show=function(){var t;return t=$.extend(!0,{},this.opts.modal_options,{show:!0}),this.modal=this.$el.modal(t).data("bs.modal"),this.modal.$backdrop.appendTo("body").addClass("muui-modal-backdrop")},i.prototype.hide=function(){return this.$el.modal("hide")},i.prototype.toggle=function(){return this.$el.modal("toggle")},i.prototype._calc_top=function(){var t;return t=this.opts.offset_top,_.isFunction(t)&&(t=t.call(this)),-(this.$el.height()/2-(t||0))},i.prototype._calc_left=function(){var t;return t=this.opts.offset_left,_.isFunction(t)&&(t=t.call(this)),-(this.$el.width()/2-(t||0))},i}(t)});