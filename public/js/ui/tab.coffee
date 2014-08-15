define () ->
    class Tab
        @defaults:
            el: ''
            datasource: ''
            tmpl: 'tmpl/index'
            render_fn: 'html'
            render_done: ->
            data_filter: (r) ->
                r

        constructor: (options) ->
            @opts = opts = _.defaults(options, Tab.defaults)
            unless opts.el
                throw 'el cannot be empty.'
            @$el = $(opts.el)
            @render()

        get_datasource: ->
            datasource = @opts.datasource
            try
                datasource = JSON.parse(datasource)
            catch
                datasource = @opts.datasource
            datasource

        render: () ->
            {$el, opts} = @
            tmpl = opts.tmpl
            datasource = @get_datasource()

            if tmpl
                require([tmpl], (tmpl) ->
                    render_tmpl = (r) ->
                        tmpl = tmpl(r)
                        $el[opts.render_fn](tmpl)
                        opts.render_done(tmpl)

                    if datasource
                        _.utils.api(datasource).done (r) ->
                            render_tmpl opts.data_filter(r)
                    else
                        render_tmpl()
                )
            else
                opts.render_done()

    Tab
