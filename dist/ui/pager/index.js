var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

define(['muui/core/base'], function(Base) {
  var Pager, ceil, floor;
  ceil = Math.ceil, floor = Math.floor;
  return Pager = (function(superClass) {
    extend(Pager, superClass);

    function Pager() {
      return Pager.__super__.constructor.apply(this, arguments);
    }

    Pager.defaults = {
      el: '.muui-pager',
      renderFn: 'html',
      tmpl: _.template('<% if (!_.isEmpty(args)) { %>\n    <% var path = args.path; %>\n    <% _.each(pager, function(item) { %>\n        <% if (item === \'prev\') { %>\n            <a class="muui-pager-prev muui-pager-item"\n                data-page="<%- args.prev %>"\n                href="<%- path.replace(/{page}/g, args.prev) %>">\n                <%- args.prevLabel %>\n            </a>\n        <% } else if (item === \'prevDisabled\') { %>\n            <span class="muui-pager-prev muui-pager-disabled muui-pager-item">\n                <%- args.prevLabel %>\n            </span>\n        <% } else if (item === \'next\') { %>\n            <a class="muui-pager-next muui-pager-item"\n                data-page="<%- args.next %>"\n                href="<%- path.replace(/{page}/g, args.next) %>">\n                <%- args.nextLabel %>\n            </a>\n        <% } else if (item === \'nextDisabled\') { %>\n            <span class="muui-pager-next muui-pager-disabled muui-pager-item">\n                <%- args.nextLabel %>\n            </span>\n        <% } else if (item === \'cur\') { %>\n            <span class="muui-pager-item cur"><%- args.cur %></span>\n        <% } else if (item === \'...\') { %>\n            <span class="muui-pager-ellipse">...</span>\n        <% } else { %>\n            <a class="muui-pager-item"\n                data-page="<%- item %>"\n                href="<%- path.replace(/{page}/g, item) %>">\n                <%- item %>\n            </a>\n        <% } %>\n    <% }); %>\n<% } %>'),
      handles: {
        redirect: function() {}
      }
    };

    Pager.prototype.getOpts = function(options) {
      return $.extend(true, {}, Pager.__super__.getOpts.call(this), Pager.defaults, options);
    };

    Pager.prototype.initEvents = function() {
      var handles, itemCls;
      itemCls = 'muui-pager-item';
      handles = this.opts.handles;
      return this.$el.on('mouseenter', "a." + itemCls + ":not(.on, .cur)", function() {
        return $(this).addClass('on');
      }).on('mouseleave', "a." + itemCls, function() {
        return $(this).removeClass('on');
      }).on('click', "a." + itemCls, handles.redirect);
    };

    Pager.prototype.beforeRender = function() {
      return this.$el.addClass('loading');
    };

    Pager.prototype.afterRender = function() {
      return this.$el.removeClass('loading');
    };

    Pager.prototype.render = function(data) {
      data = _.extend(this.$el.data('pager'), data);
      data.path = '?page={page}';
      if (_.isObject(data.query)) {
        data.path += '&' + $.param(data.query);
      }
      return Pager.__super__.render.call(this, this.build(data) || {
        args: null
      });
    };

    Pager.prototype.build = function(data) {
      var canFill, cur, hasNext, hasPrev, i, j, k, l, length, m, offset, pageNum, r, ref, ref1, ref2, ref3, results, results1, results2, results3, size, total;
      data = _.extend({
        size: 10,
        length: 7,
        prevLabel: '上一页',
        nextLabel: '下一页'
      }, data);
      cur = data.cur, total = data.total, size = data.size, length = data.length;
      if (total <= size) {
        return null;
      }
      pageNum = ceil(total / size);
      canFill = false;
      if (pageNum < length) {
        length = pageNum;
        canFill = true;
      }
      if (!((1 <= (ref = (cur = ~~cur)) && ref <= pageNum))) {
        cur = 1;
      }
      if (cur !== 1) {
        hasPrev = true;
        data.prev = cur - 1;
      }
      if (cur !== pageNum) {
        hasNext = true;
        data.next = cur + 1;
      }
      if (canFill) {
        r = (function() {
          results = [];
          for (var i = 1; 1 <= pageNum ? i <= pageNum : i >= pageNum; 1 <= pageNum ? i++ : i--){ results.push(i); }
          return results;
        }).apply(this);
      } else {
        offset = floor((length - 1) / 2);
        if (cur - offset < 1) {
          r = (function() {
            results1 = [];
            for (var j = 1; 1 <= length ? j <= length : j >= length; 1 <= length ? j++ : j--){ results1.push(j); }
            return results1;
          }).apply(this);
        } else if (cur + offset > pageNum - 2) {
          r = (function() {
            results2 = [];
            for (var k = ref1 = pageNum - length; ref1 <= pageNum ? k <= pageNum : k >= pageNum; ref1 <= pageNum ? k++ : k--){ results2.push(k); }
            return results2;
          }).apply(this);
        } else {
          r = (function() {
            results3 = [];
            for (var m = ref2 = cur - offset, ref3 = cur + length - 1 - offset; ref2 <= ref3 ? m <= ref3 : m >= ref3; ref2 <= ref3 ? m++ : m--){ results3.push(m); }
            return results3;
          }).apply(this);
        }
      }
      if (r.length === 1) {
        return null;
      } else if (!canFill) {
        if (r[0] !== 1) {
          r[0] = 1;
          if (r[1] !== cur) {
            r[1] = '...';
          }
        }
        l = r.length;
        if (r[l - 1] !== pageNum) {
          r[l - 1] = pageNum;
          r[l - 2] = '...';
        }
      }
      r[_.indexOf(r, cur)] = 'cur';
      r.unshift(hasPrev && 'prev' || 'prevDisabled');
      r.push(hasNext && 'next' || 'nextDisabled');
      return {
        args: _.merge(data, {
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
});
