define [
    'muui/core/utils'
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

        get_opts: (options) ->
            $.extend({}, MuUI.defaults, options)

        constructor: (options) ->
            @opts = opts = @get_opts(options)
            unless opts.el
                throw new Error 'el cannot be empty.'
            @$el = $(opts.el)
            @render(opts.render_args).done =>
                @init_events()

        render: ->
            { $el, opts } = @
            {
                before_render, after_render
                render_fn, tmpl
                datasource, data_filter
            } = opts

            before_render()
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
                        after_render(r, $tmpl)

                    if datasource
                        utils.api(datasource).done (r) ->
                            render_tmpl data_filter(r)
                    else
                        render_tmpl(opts.data or {})
                )
            else
                def.resolve()
                after_render()

            def.promise()

        init_events: ->

    MuUI
