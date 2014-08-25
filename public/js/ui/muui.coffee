define [
    'muui/core/utils'
], (utils) ->
    class MuUI
        @defaults:
            el: ''
            datasource: ''
            render_fn: 'replaceWith'
            data_filter: (r) ->
                r

        get_opts: (options) ->
            $.extend({}, MuUI.defaults, options)

        constructor: (options) ->
            @opts = opts = @get_opts(options)
            unless opts.el
                throw 'el cannot be empty.'
            @$el = $(opts.el)
            @render().done =>
                @init_events()

        get_datasource: ->
            datasource = @opts.datasource
            try
                datasource = JSON.parse(datasource)
            catch
                datasource = @opts.datasource
            datasource

        render: ->
            @before_render()
            {$el, opts} = @
            def = $.Deferred()
            tmpl = opts.tmpl

            if tmpl
                require([tmpl], (tmpl) =>
                    render_fn = opts.render_fn
                    render_tmpl = (r) =>
                        $tmpl = $(tmpl(r))
                        $el[render_fn]($tmpl)
                        if render_fn is 'replaceWith'
                            @$el = $tmpl
                        def.resolve(r, $tmpl)
                        @after_render(r, $tmpl)

                    datasource = @get_datasource()
                    if datasource
                        utils.api(datasource).done (r) ->
                            render_tmpl opts.data_filter(r)
                    else
                        render_tmpl()
                )
            else
                def.resolve()
                @after_render()

            def.promise()

        before_render: ->

        after_render: ->

        init_events: ->

    MuUI
