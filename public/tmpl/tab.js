define(function() {
    return function (obj) {
obj || (obj = {});
var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
function print() { __p += __j.call(arguments, '') }
with (obj) {
__p += '<ul class="muui-tab">\n    ';

        if (typeof cur === 'undefined') {
            cur = items[0].target;
        }
    ;
__p += '\n\n    ';
 _.each(items, function(item, i) { ;
__p += '\n        <li class="muui-tab-item' +
__e( cur === item.target ? ' on' : '' ) +
'' +
__e( i === 0 ? ' first' : '' ) +
'" data-target="' +
__e( item.target ) +
'">' +
__e( item.name ) +
'</li>\n    ';
 }); ;
__p += '\n</ul>\n';

}
return __p
}
});