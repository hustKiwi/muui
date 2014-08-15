define(() ->
    StrProto = String.prototype

    unless _.isFunction(StrProto.startsWith)
        StrProto.startsWith = (str) ->
            @slice(0, str.length) is str

    unless _.isFunction(StrProto.endsWith)
        StrProto.endsWith = (str) ->
            return @slice(-str.length) is str

    animation_listener = (type, el, options) ->
        return unless type in ['add', 'remove']

        do (el, options) ->
            pfx = ['webkit', 'moz', 'MS', 'o', '']
            defaults = {
                type: ''
                callback: () ->
            }
            opts = _.extend(defaults, options)

            return unless _.include([
                'AnimationStart',
                'AnimationIteration',
                'AnimationEnd'
            ], opts.type)

            for p in pfx
                type = type.toLowerCase() unless p
                el["#{type}EventListener"](p + opts.type, opts.callback, false)

    utils =
        api: (url, data, options) ->
            def = $.Deferred()

            defaults =
                type: if cfg.debug then 'GET' else 'POST'
                dataType: 'json'
                handleError: (r) ->
                    console?.error(r)

            if _.isArray(url)
                data =
                    apis: JSON.stringify(url)
                url = 'multi'
            else if _.isObject(url)
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
                    code = r.code
                    if code is cfg.apiCode.SUCCESS
                        def.resolve(r)
                    else
                        def.reject(r)
                        opts.handleError(r, url, data)

                # 调用错误很少见, 可以不做处理
                error: ->
                    def.reject()
                    opts.handleError('ajax error')

            def.promise()

        # 监听animation事件，参考:
        # http://www.sitepoint.com/css3-animation-javascript-event-handlers/
        # https://developer.mozilla.org/en-US/docs/CSS/Tutorials/Using_CSS_animations
        # type可填: AnimationStart, AnimationIteration, AnimationEnd
        add_animation_listener: (el, options) ->
            animation_listener('add', el, options)

        remove_animation_listener: (el, options) ->
            animation_listener('remove', el, options)

        trans_end_event: ->
            events =
                'WebkitTransition': 'webkitTransitionEnd'
                'MozTransition': 'transitionend'
                'OTransition': 'oTransitionEnd'
                'msTransition': 'MSTransitionEnd'
                'transition': 'transitionend'
            events[Modernizr.prefixed('transition')]

        to_num: (num) ->
            Number(num.endsWith('px') and num.slice(0, -2) or num)

        capitalize: (name) ->
            name.charAt(0).toUpperCase() + name.substring(1).toLowerCase()

    _.utils = utils
)
