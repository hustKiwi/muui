define () ->
    class Tab
        @defaults:
            el: ''
            tmpl: 'tmpl/index'
            render_fn: 'html'
            render_done: ->

        constructor: (options) ->
            @opts = opts = _.defaults(options, Tab.defaults)
            unless opts.el
                throw 'el cannot be empty.'
            @$el = $(opts.el)
            @render()

        render: () ->
            opts = @opts
            tmpl = opts.tmpl
            if tmpl
                require([tmpl], (tmpl) =>
                    tmpl = tmpl()
                    @$el[opts.render_fn](tmpl)
                    opts.render_done(tmpl)
                )
            else
                opts.render_done()

    Tab
