var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define(['muui/core/base'], function(Base) {
  var Pager, ceil, floor;
  ceil = Math.ceil, floor = Math.floor;
  Pager = (function(_super) {
    __extends(Pager, _super);

    function Pager() {
      return Pager.__super__.constructor.apply(this, arguments);
    }

    Pager.defaults = {
      el: '.muui-pager',
      tmpl: _.template('<% var path = args.path; %>\n<div class="muui-pager">\n<% _.each(pager, function(item) { %>\n    <% if (item === \'prev\') { %>\n        <a class="muui-pager-prev muui-pager-item"\n            data-page="<%- args.prev %>"\n            href="<%- path.replace(/{page}/g, args.prev) %>">\n            <%- args.prev_lable %>\n        </a>\n    <% } else if (item === \'prev_disabled\') { %>\n        <span class="muui-pager-prev muui-pager-disabled muui-pager-item">\n            <%- args.prev_lable %>\n        </span>\n    <% } else if (item === \'next\') { %>\n        <a class="muui-pager-next muui-pager-item"\n            data-page="<%- args.next %>"\n            href="<%- path.replace(/{page}/g, args.next) %>">\n            <%- args.next_lable %>\n        </a>\n    <% } else if (item === \'next_disabled\') { %>\n        <span class="muui-pager-next muui-pager-disabled muui-pager-item">\n            <%- args.next_lable %>\n        </span>\n    <% } else if (item === \'cur\') { %>\n        <span class="muui-pager-item cur"><%- args.cur %></span>\n    <% } else if (item === \'...\') { %>\n        <span class="muui-pager-ellipse">...</span>\n    <% } else { %>\n        <a class="muui-pager-item"\n            data-page="<%- item %>"\n            href="<%- path.replace(/{page}/g, item) %>">\n            <%- item %>\n        </a>\n    <% } %>\n<% }); %>\n</div>'),
      handles: {
        redirect: function(e) {}
      }
    };

    Pager.prototype.get_opts = function(options) {
      return $.extend(true, {}, Pager.__super__.get_opts.call(this), Pager.defaults, options);
    };

    Pager.prototype.init_events = function() {
      var handles, item_cls;
      item_cls = 'muui-pager-item';
      handles = this.opts.handles;
      return this.$el.on('mouseenter', "a." + item_cls + ":not(.on, .cur)", function() {
        return $(this).addClass('on');
      }).on('mouseleave', "a." + item_cls, function() {
        return $(this).removeClass('on');
      }).on('click', "." + item_cls, handles.redirect);
    };

    Pager.prototype.render = function(data) {
      return Pager.__super__.render.call(this, this.build(data));
    };

    Pager.prototype.build = function(data) {
      var cur, has_next, has_prev, l, length, offset, page_num, r, size, total, _i, _j, _k, _ref, _ref1, _ref2, _ref3, _results, _results1, _results2;
      _.defaults(data, {
        path: '',
        size: 10,
        length: 7,
        prev_lable: '上一页',
        next_lable: '下一页'
      });
      cur = data.cur, total = data.total, size = data.size, length = data.length;
      page_num = ceil(total / size);
      if (page_num < length) {
        length = page_num;
      }
      if (length < 7) {
        length = 2;
      }
      if (!((1 <= (_ref = (cur = ~~cur)) && _ref <= page_num))) {
        cur = 1;
      }
      if (cur !== 1) {
        has_prev = true;
        data.prev = cur - 1;
      }
      if (cur !== page_num) {
        has_next = true;
        data.next = cur + 1;
      }
      offset = floor((length - 1) / 2);
      if (cur - offset < 1) {
        r = (function() {
          _results = [];
          for (var _i = 1; 1 <= length ? _i <= length : _i >= length; 1 <= length ? _i++ : _i--){ _results.push(_i); }
          return _results;
        }).apply(this);
      } else if (cur + offset > page_num - 2) {
        r = (function() {
          _results1 = [];
          for (var _j = _ref1 = page_num - length; _ref1 <= page_num ? _j <= page_num : _j >= page_num; _ref1 <= page_num ? _j++ : _j--){ _results1.push(_j); }
          return _results1;
        }).apply(this);
      } else {
        r = (function() {
          _results2 = [];
          for (var _k = _ref2 = cur - offset, _ref3 = cur + length - 1 - offset; _ref2 <= _ref3 ? _k <= _ref3 : _k >= _ref3; _ref2 <= _ref3 ? _k++ : _k--){ _results2.push(_k); }
          return _results2;
        }).apply(this);
      }
      if (r.length === 1) {
        return [];
      } else if (length !== 2) {
        if (r[0] !== 1) {
          r[0] = 1;
          if (r[1] !== cur) {
            r[1] = '...';
          }
        }
        l = r.length;
        if (r[l - 1] !== page_num) {
          r[l - 1] = page_num;
          r[l - 2] = '...';
        }
        r[_.indexOf(r, cur)] = 'cur';
      } else {
        r.length = 0;
      }
      r.unshift(has_prev && 'prev' || 'prev_disabled');
      r.push(has_next && 'next' || 'next_disabled');
      return {
        args: _.extend(data, {
          cur: cur,
          total: total,
          size: size,
          length: length
        }),
        pager: r
      };
    };

    return Pager;

  })(Base);
  return Pager;
});
