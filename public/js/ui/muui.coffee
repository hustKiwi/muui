define [
    'muui/core/utils'
], (utils) ->
    class MuUI
        @defaults:
            el: ''
            datasource: ''
            render_fn: 'replaceWith'
            render_done: (r) =>
            data_filter: (r) ->
                r

        get_opts: (options) ->
            $.extend({}, MuUI.defaults, options)

        constructor: (options) ->
            @opts = opts = @get_opts(options)
            unless opts.el
                throw 'el cannot be empty.'
            @$el = $(opts.el)
            @before_render()
            @render().done =>
                @init_events()
                @after_render()

        get_datasource: ->
            datasource = @opts.datasource
            try
                datasource = JSON.parse(datasource)
            catch
                datasource = @opts.datasource
            datasource

        render: ->
            {$el, opts} = @
            def = $.Deferred()
            tmpl = opts.tmpl
            render_fn = opts.render_fn
            datasource = @get_datasource()

            if tmpl
                require([tmpl], (tmpl) =>
                    render_tmpl = (r) =>
                        $tmpl = $(tmpl(r))
                        $el[render_fn]($tmpl)
                        if render_fn is 'replaceWith'
                            @$el = $tmpl
                        def.resolve(r, $tmpl)
                        opts.render_done(r, $tmpl)

                    if datasource
                        utils.api(datasource).done (r) ->
                            render_tmpl opts.data_filter(r)
                    else
                        render_tmpl()
                )
            else
                def.resolve()
                opts.render_done()

            def.promise()

        before_render: ->

        after_render: ->

        init_events: ->

    MuUI
