var extend=function(t,o){function i(){this.constructor=t}for(var n in o)hasProp.call(o,n)&&(t[n]=o[n]);return i.prototype=o.prototype,t.prototype=new i,t.__super__=o.prototype,t},hasProp={}.hasOwnProperty;define(["muui/core/base","muui/core/utils","muui/lib/bootstrap/modal","muui/lib/bootstrap/transition"],function(t,o){var i,n,e,s,r,a,d,l;for(n=$(document),i=$("body"),e=function(t){function o(){return o.__super__.constructor.apply(this,arguments)}return extend(o,t),o.defaults={el:".muui-modal",container:'<div class="muui-modal fade" tabindex="-1" style="display: none;"></div>',tmpl:_.template('<div class="muui-modal-stick"></div>\n<div class="<%- cls && cls + \' \' || \'\' %>muui-modal-dialog modal-dialog">\n    <div class="muui-modal-header">\n        <h3><%= title %></h3>\n        <% if (btns.close) { %>\n            <a class="close" data-dismiss="modal" aria-hidden="true" href="javascript:;">×</a>\n        <% } %>\n    </div>\n    <div class="muui-modal-body"><%= body %></div>\n    <div class="muui-modal-footer">\n        <% if (_.isEmpty(footer)) { %>\n            <% if (btns.submit) { %>\n                <button class="muui-btn muui-btn-primary submit" data-dismiss="modal" aria-hidden="true">确定</button>\n            <% } %>\n            <% if (btns.cancel) { %>\n                <button class="muui-btn" data-dismiss="modal" aria-hidden="true">取消</button>\n            <% } %>\n        <% } else { %>\n            <%= footer %>\n        <% } %>\n    </div>\n</div>'),loadingTmpl:'<div class="loading-panel">\n    <i class="ui-loading"></i>\n    <p class="tip">\n        正在加载，请稍候 ...\n    </p>\n</div>',renderArgs:{title:"",cls:"",btns:{close:!0,submit:!0,cancel:!0},body:"",footer:""},renderFn:"html",modalOptions:{show:!1,backdrop:!0}},o.prototype.getOpts=function(t){return $.extend(!0,{},o.__super__.getOpts.call(this),o.defaults,t)},o.prototype.initEvents=function(){var t;return t=this.$el,t.on("click",".muui-modal-footer .muui-btn",function(){return $(this).blur()}).on("hide.bs.modal",function(){return t.empty()})},o.prototype.beforeRender=function(){var t,o;return t=this.$el,o=this.opts,t.length?void 0:(this.$el=$(o.container).appendTo(i),this.$dialog=this.$el.find(".muui-modal-dialog"))},o.prototype.afterRender=function(){return this.modal=this.$el.modal(this.opts.modalOptions).data("bs.modal")},o.prototype.show=function(){return this.render(this.opts.renderArgs).done(function(t){return function(){return t.modal.show()}}(this)),this},o.prototype.hide=function(){return this.modal.hide(),this},o.prototype.toggle=function(){return this.modal.toggle(),this},o.prototype.loading=function(){return this.setModalBody(this.opts.loadingTmpl).$el.addClass("muui-modal-loading"),this},o.prototype.setModalBody=function(t){var o,i;return o=this.$el,i=this.opts,o.find(".muui-modal-body").html(t),t!==i.loadingTmpl&&o.removeClass("muui-modal-loading"),this},o.prototype.setTitle=function(t){return this.opts.renderArgs.title=t,this.$el.find(".muui-modal-header h3").text(t),this},o}(t),l=["header","footer"],s=function(t){return e.prototype["setModal"+_.capitalize(t)]=function(o){return this.$el.find(".muui-modal-"+t).html(o),this}},r=0,d=l.length;d>r;r++)a=l[r],s(a);return e});