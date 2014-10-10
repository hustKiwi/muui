define [
    'core/utils'
], (utils) ->
    class MuUI
        @defaults:
            el: ''
            datasource: ''
            render_args: {}
            render_fn: 'replaceWith'
            data_filter: (r) ->
                r
            before_render: ->
            after_render: ->

        get_opts: ->
            MuUI.defaults

        constructor: (options) ->
            @opts = opts = @get_opts(options)

            unless opts.el
                throw new Error 'el cannot be empty.'
            @$el = $(opts.el)

            @before_render()
            opts.before_render()

            @render(opts.render_args).done (args...) =>
                @after_render([ args ])
                opts.after_render([ args ])
                @init_events()

        render: ->
            { $el, opts } = @
            {
                render_fn, tmpl
                datasource, data_filter
            } = opts

            def = $.Deferred()

            if tmpl
                require([
                    "text!#{tmpl}.html"
                ], (tmpl) =>
                    render_tmpl = (r) =>
                        $tmpl = $(_.template(tmpl)(r))
                        $el[render_fn]($tmpl)
                        if render_fn is 'replaceWith'
                            @$el = $tmpl
                        def.resolve(r, $tmpl)

                    if datasource
                        utils.api(datasource).done (r) ->
                            render_tmpl data_filter(r)
                    else
                        render_tmpl(opts.data or {})
                )
            else
                def.resolve()

            def.promise()

        ###
        # 以下方法暴露给子类覆盖
        ###
        init_events: ->

        before_render: ->

        after_render: ->

    MuUI
