var __hasProp={}.hasOwnProperty,__extends=function(e,t){function r(){this.constructor=e}for(var n in t)__hasProp.call(t,n)&&(e[n]=t[n]);return r.prototype=t.prototype,e.prototype=new r,e.__super__=t.prototype,e};define(["core/muui"],function(e){var t,r,n;return r=Math.ceil,n=Math.floor,t=function(e){function t(){return t.__super__.constructor.apply(this,arguments)}return __extends(t,e),t.defaults={el:".muui-pager",tmpl:_.template('<% var path = args.path; %>\n<div class="muui-pager">\n<% _.each(pager, function(item) { %>\n    <% if (item === \'prev\') { %>\n        <a class="muui-pager-prev muui-pager-item"\n            data-page="<%- args.prev %>"\n            href="<%- path.replace(/{page}/g, args.prev) %>">\n            <%- args.prev_lable %>\n        </a>\n    <% } else if (item === \'next\') { %>\n        <a class="muui-pager-next muui-pager-item"\n            data-page="<%- args.next %>"\n            href="<%- path.replace(/{page}/g, args.next) %>">\n            <%- args.next_lable %>\n        </a>\n    <% } else if (item === \'cur\') { %>\n        <span class="muui-pager-item cur"><%- args.cur %></span>\n    <% } else if (item === \'...\') { %>\n        <span class="muui-pager-ellipse">...</span>\n    <% } else { %>\n        <a class="muui-pager-item"\n            data-page="<%- item %>"\n            href="<%- path.replace(/{page}/g, item) %>">\n            <%- item %>\n        </a>\n    <% } %>\n<% }); %>\n</div>'),handles:{redirect:function(){}}},t.prototype.get_opts=function(e){return $.extend({},t.defaults,t.__super__.get_opts.call(this,e))},t.prototype.init_events=function(){var e,t;return t="muui-pager-item",e=this.opts.handles,this.$el.on("mouseenter","."+t+":not(.on, .cur)",function(){return $(this).addClass("on")}).on("mouseleave","."+t,function(){return $(this).removeClass("on")}).on("click","."+t,e.redirect)},t.prototype.render=function(e){var t,r,n,a,p,i,s;return p=this.opts,n=p.before_render,r=p.after_render,i=p.render_fn,s=p.tmpl,this.$el=t=$(p.el),n(),a=$.Deferred(),function(e){return function(n){var p,u;return u=function(e){return a.resolve(e),r(e)},n.pager.length?(_.isString(s)&&(s=_.template(s)),p=$(s(n)),t[i](p),"replaceWith"===i&&(e.$el=p),u(n)):u(n)}}(this)(this.build(e)),a.promise()},t.prototype.build=function(e){var t,a,p,i,s,u,o,l,c,h,g,f,m,d,v,x;return _.defaults(e,{path:"",size:10,length:7,prev_lable:"上一页",next_lable:"下一页"}),t=e.cur,h=e.total,c=e.size,s=e.length,o=r(h/c),s>o&&(s=o),7>s&&(s=2),1<=(g=t=~~t)&&o>=g||(t=1),1!==t&&(p=!0,e.prev=t-1),t!==o&&(a=!0,e.next=t+1),u=n((s-1)/2),l=1>t-u?function(){d=[];for(var e=1;s>=1?s>=e:e>=s;s>=1?e++:e--)d.push(e);return d}.apply(this):t+u>o-2?function(){v=[];for(var e=f=o-s;o>=f?o>=e:e>=o;o>=f?e++:e--)v.push(e);return v}.apply(this):function(){x=[];for(var e=m=t-u,r=t+s-1-u;r>=m?r>=e:e>=r;r>=m?e++:e--)x.push(e);return x}.apply(this),1===l.length?[]:(2!==s?(1!==l[0]&&(l[0]=1,l[1]!==t&&(l[1]="...")),i=l.length,l[i-1]!==o&&(l[i-1]=o,l[i-2]="..."),l[_.indexOf(l,t)]="cur"):l.length=0,p&&l.unshift("prev"),a&&l.push("next"),{args:_.extend(e,{cur:t,total:h,size:c,length:s}),pager:l})},t}(e)});