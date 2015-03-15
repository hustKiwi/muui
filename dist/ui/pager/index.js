var extend=function(e,n){function t(){this.constructor=e}for(var r in n)hasProp.call(n,r)&&(e[r]=n[r]);return t.prototype=n.prototype,e.prototype=new t,e.__super__=n.prototype,e},hasProp={}.hasOwnProperty;define(["muui/core/base"],function(e){var n,t,r;return t=Math.ceil,r=Math.floor,n=function(e){function n(){return n.__super__.constructor.apply(this,arguments)}return extend(n,e),n.defaults={el:".muui-pager",tmpl:_.template('<% if (args.none) { %>\n<% } else { %>\n    <% var path = args.path; %>\n    <div class="muui-pager">\n    <% _.each(pager, function(item) { %>\n        <% if (item === \'prev\') { %>\n            <a class="muui-pager-prev muui-pager-item"\n                data-page="<%- args.prev %>"\n                href="<%- path.replace(/{page}/g, args.prev) %>">\n                <%- args.prev_lable %>\n            </a>\n        <% } else if (item === \'prev_disabled\') { %>\n            <span class="muui-pager-prev muui-pager-disabled muui-pager-item">\n                <%- args.prev_lable %>\n            </span>\n        <% } else if (item === \'next\') { %>\n            <a class="muui-pager-next muui-pager-item"\n                data-page="<%- args.next %>"\n                href="<%- path.replace(/{page}/g, args.next) %>">\n                <%- args.next_lable %>\n            </a>\n        <% } else if (item === \'next_disabled\') { %>\n            <span class="muui-pager-next muui-pager-disabled muui-pager-item">\n                <%- args.next_lable %>\n            </span>\n        <% } else if (item === \'cur\') { %>\n            <span class="muui-pager-item cur"><%- args.cur %></span>\n        <% } else if (item === \'...\') { %>\n            <span class="muui-pager-ellipse">...</span>\n        <% } else { %>\n            <a class="muui-pager-item"\n                data-page="<%- item %>"\n                href="<%- path.replace(/{page}/g, item) %>">\n                <%- item %>\n            </a>\n        <% } %>\n    <% }); %>\n    </div>\n<% } %>'),handles:{redirect:function(){}}},n.prototype.get_opts=function(e){return $.extend(!0,{},n.__super__.get_opts.call(this),n.defaults,e)},n.prototype.init_events=function(){var e,n;return n="muui-pager-item",e=this.opts.handles,this.$el.on("mouseenter","a."+n+":not(.on, .cur)",function(){return $(this).addClass("on")}).on("mouseleave","a."+n,function(){return $(this).removeClass("on")}).on("click","."+n,e.redirect)},n.prototype.render=function(e){return e=this.build(e),n.__super__.render.call(this,e&&e||{args:{none:!0}})},n.prototype.build=function(e){var n,a,p,s,i,u,l,o,g,c,h,m,f,d,v,x,b,y;return _.defaults(e,{path:"?page={page}",size:10,length:7,prev_lable:"上一页",next_lable:"下一页"}),a=e.cur,y=e.total,b=e.size,u=e.length,b>=y?null:(o=t(y/b),n=!1,u>o&&(u=o,n=!0),1<=(c=a=~~a)&&o>=c||(a=1),1!==a&&(s=!0,e.prev=a-1),a!==o&&(p=!0,e.next=a+1),n?g=function(){f=[];for(var e=1;o>=1?o>=e:e>=o;o>=1?e++:e--)f.push(e);return f}.apply(this):(l=r((u-1)/2),g=1>a-l?function(){d=[];for(var e=1;u>=1?u>=e:e>=u;u>=1?e++:e--)d.push(e);return d}.apply(this):a+l>o-2?function(){v=[];for(var e=h=o-u;o>=h?o>=e:e>=o;o>=h?e++:e--)v.push(e);return v}.apply(this):function(){x=[];for(var e=m=a-l,n=a+u-1-l;n>=m?n>=e:e>=n;n>=m?e++:e--)x.push(e);return x}.apply(this)),1===g.length?null:(1!==g[0]&&(g[0]=1,g[1]!==a&&(g[1]="...")),i=g.length,g[i-1]!==o&&(g[i-1]=o,g[i-2]="..."),g[_.indexOf(g,a)]="cur",g.unshift(s&&"prev"||"prev_disabled"),g.push(p&&"next"||"next_disabled"),{args:_.merge(e,{cur:a,total:y,size:b,length:u}),pager:g}))},n}(e)});