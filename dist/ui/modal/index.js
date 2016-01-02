var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

define(['muui/core/base', 'muui/core/utils', 'muui/lib/bootstrap/modal', 'muui/lib/bootstrap/transition'], function(Base, utils) {
  var $body, $doc, Modal, fn, i, item, len, ref;
  $doc = $(document);
  $body = $('body');
  Modal = (function(superClass) {
    extend(Modal, superClass);

    function Modal() {
      return Modal.__super__.constructor.apply(this, arguments);
    }

    Modal.defaults = {
      id: 0,
      container: '<div class="muui-modal fade" data-id=' + (++Modal.defaults.id) + 'tabindex="-1" style="display: none;"></div>',
      tmpl: _.template('<div class="muui-modal-stick"></div>\n<div class="<%- cls && cls + \' \' || \'\' %>muui-modal-dialog modal-dialog<%- title ? \'\' : \' without-title\' %>">\n    <div class="muui-modal-header">\n        <h3><%= title %></h3>\n        <% if (btns.close) { %>\n            <a class="close" data-dismiss="modal" aria-hidden="true" href="javascript:;">×</a>\n        <% } %>\n    </div>\n    <div class="muui-modal-body"><%= body %></div>\n    <div class="muui-modal-footer">\n        <% if (_.isEmpty(footer)) { %>\n            <% if (btns.submit) { %>\n                <button class="muui-btn muui-btn-primary submit" data-dismiss="modal" aria-hidden="true">确定</button>\n            <% } %>\n            <% if (btns.cancel) { %>\n                <button class="muui-btn" data-dismiss="modal" aria-hidden="true">取消</button>\n            <% } %>\n        <% } else { %>\n            <%= footer %>\n        <% } %>\n    </div>\n</div>'),
      loadingTmpl: '<div class="loading-panel">\n    <i class="ui-loading"></i>\n    <p class="tip">\n        正在加载，请稍候 ...\n    </p>\n</div>',
      renderArgs: {
        title: '',
        cls: '',
        btns: {
          close: true,
          submit: true,
          cancel: true
        },
        body: '',
        footer: ''
      },
      renderFn: 'html',
      modalOptions: {
        show: false,
        backdrop: true
      }
    };

    Modal.prototype.getOpts = function(options) {
      return $.extend(true, {}, Modal.__super__.getOpts.call(this), Modal.defaults, options);
    };

    Modal.prototype.initEvents = function() {
      var $el;
      $el = this.$el;
      return $el.off().on('click', '.muui-modal-footer .muui-btn', function() {
        return $(this).blur();
      }).on('show.bs.modal, hide.bs.modal', function() {
        return $el.removeClass('muui-modal-loading');
      });
    };

    Modal.prototype.beforeRender = function() {
      return this.$el = $(this.opts.container).appendTo($body);
    };

    Modal.prototype.afterRender = function() {
      return this.modal = this.$el.modal(this.opts.modalOptions).removeClass('muui-modal-loading').data('bs.modal');
    };

    Modal.prototype.show = function() {
      this.modal.show();
      return this;
    };

    Modal.prototype.hide = function() {
      this.modal.hide();
      return this;
    };

    Modal.prototype.toggle = function() {
      this.modal.toggle();
      return this;
    };

    Modal.prototype.loading = function() {
      this.setModalBody(this.opts.loadingTmpl).$el.addClass('muui-modal-loading');
      return this;
    };

    Modal.prototype.setModalBody = function(html) {
      var $el, opts;
      $el = this.$el, opts = this.opts;
      $el.find('.muui-modal-body').html(html);
      if (html !== opts.loadingTmpl) {
        $el.removeClass('muui-modal-loading');
      }
      return this;
    };

    Modal.prototype.setTitle = function(title) {
      this.$el.removeClass('without-title').find('.muui-modal-header h3').text(title);
      return this;
    };

    return Modal;

  })(Base);
  ref = ['header', 'footer'];
  fn = function(item) {
    return Modal.prototype["setModal" + (_.capitalize(item))] = function(html) {
      this.$el.find(".muui-modal-" + item).html(html);
      return this;
    };
  };
  for (i = 0, len = ref.length; i < len; i++) {
    item = ref[i];
    fn(item);
  }
  return Modal;
});
