define(function(){var e;return e=String.prototype,_.isFunction(e.startsWith)||(e.startsWith=function(e){return this.slice(0,e.length)===e}),_.isFunction(e.endsWith)||(e.endsWith=function(e){return this.slice(-e.length)===e}),{api:function(e,n,t){var r,o,i;return r=$.Deferred(),o={type:"GET",dataType:"jsonp",handleError:function(e){return"undefined"!=typeof console&&null!==console&&"function"==typeof console.error?console.error(e):void 0}},_.isObject(e)&&(t=n,n=e.data,e=e.url),i=$.extend(o,t),null==n&&(n={}),$.ajax({url:e,data:n,dataType:i.dataType,type:i.type,success:function(e){return r.resolve(e)},error:function(){return r.reject(),i.handleError("ajax error")}}),r.promise()},is_template:function(e){return _.isFunction(e)&&"source"in e},is_ie6:function(){return"undefined"==typeof document.body.style.maxHeight}}});