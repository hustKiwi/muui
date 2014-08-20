define () ->
    class Tab
        @defaults:
            el: ''
            datasource: ''
            tmpl: 'tmpl/tab'
            render_fn: 'replaceWith'
            render_done: (r) =>
            data_filter: (r) ->
                r

        constructor: (options) ->
            @opts = opts = _.defaults(options, Tab.defaults)
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
                        _.utils.api(datasource).done (r) ->
                            render_tmpl opts.data_filter(r)
                    else
                        render_tmpl()
                )
            else
                def.resolve()
                opts.render_done()

            def.promise()

        init_events: ->
            @$el.on 'mouseenter', '.nav-item:not(.on)', ->
                $(@).addClass('hover')
            .on 'mouseleave', '.nav-item:not(.on)', ->
                $(@).removeClass('hover')
            .on 'click', '.nav-item:not(.on)', ->
                $this = $(@)
                $this.siblings('.on').removeClass('on').end()
                    .removeClass('hover').addClass('on')
                $($this.data('target')).siblings('.on').removeClass('on')
                    .end().addClass('on')
                return false

    Tab
