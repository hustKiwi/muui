define( ->
    StrProto = String.prototype

    unless _.isFunction(StrProto.startsWith)
        StrProto.startsWith = (str) ->
            @slice(0, str.length) is str

    unless _.isFunction(StrProto.endsWith)
        StrProto.endsWith = (str) ->
            @slice(-str.length) is str

    return {
        api: (url, data, options) ->
            def = $.Deferred()

            defaults =
                type: 'GET'
                dataType: 'jsonp'
                handleError: (r) ->
                    console?.error?(r)

            if _.isObject(url)
                options = data
                data = url.data
                url = url.url

            opts = $.extend(defaults, options)
            data ?= {}

            $.ajax
                url: url
                data: data
                dataType: opts.dataType
                type: opts.type

                success: (r) ->
                    def.resolve(r)

                # 调用错误很少见, 可以不做处理
                error: ->
                    msg = 'ajax error'
                    def.reject(msg)
                    opts.handleError(msg)

            def.promise()

        # http://stackoverflow.com/questions/18410421/detect-instanceof-underscore-template
        is_template: (tmpl) ->
            _.isFunction(tmpl) and 'source' of tmpl

        is_ie6: ->
            typeof document.body.style.maxHeight is 'undefined'
    }
)
