var __hasProp={}.hasOwnProperty,__extends=function(t,o){function n(){this.constructor=t}for(var i in o)__hasProp.call(o,i)&&(t[i]=o[i]);return n.prototype=o.prototype,t.prototype=new n,t.__super__=o.prototype,t};define(["muui/core/base","muui/core/utils","muui/lib/bootstrap/modal","muui/lib/bootstrap/transition"],function(t){var o,n,i;return n=$(document),o=$("body"),i=function(t){function n(){return n.__super__.constructor.apply(this,arguments)}return __extends(n,t),n.defaults={el:".muui-modal",container:'<div class="muui-modal fade" tabindex="-1" style="display: none;"></div>',tmpl:_.template('<div class="muui-modal-stick"></div>\n<div class="<%- cls && cls + \' \' || \'\' %>muui-modal-dialog modal-dialog">\n    <div class="muui-modal-header">\n        <% if (title) { %>\n            <h3><%= title %></h3>\n        <% } %>\n        <% if (btns.close) { %>\n            <span class="close" data-dismiss="modal" aria-hidden="true">×</span>\n        <% } %>\n    </div>\n    <div class="muui-modal-body"><%= body %></div>\n    <div class="muui-modal-footer">\n        <% if (btns.submit) { %>\n            <button class="muui-btn muui-btn-primary submit" data-dismiss="modal" aria-hidden="true">确定\n        <% } %>\n        <% if (btns.cancel) { %>\n            <button class="muui-btn" data-dismiss="modal" aria-hidden="true">取消</button>\n        <% } %>\n        <%= footer %>\n    </div>\n</div>'),data:{title:"",cls:"",btns:{close:!0,submit:!0,cancel:!0},body:"",footer:""},render_fn:"html",modal_options:{show:!1,backdrop:"static"}},n.prototype.get_opts=function(t){return _.merge(n.__super__.get_opts.call(this),_.clone(n.defaults),t)},n.prototype.init_events=function(){return this.$el.on("click",".muui-modal-footer .muui-btn",function(){return $(this).blur()}),this.$el.on("keydown.dismiss.bs.modal",function(t){return console.log(t.which)})},n.prototype.before_render=function(){return this.$el.length?void 0:this.$el=$(this.opts.container).appendTo(o)},n.prototype.after_render=function(){return this.modal=this.$el.modal(this.opts.modal_options).data("bs.modal")},n.prototype.show=function(){return this.$el.modal("show")},n.prototype.hide=function(){return this.$el.modal("hide")},n.prototype.toggle=function(){return this.$el.modal("toggle")},n}(t)});