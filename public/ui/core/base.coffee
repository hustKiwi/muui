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
            init_events: ->

        get_opts: ->
            MuUI.defaults

        constructor: (options) ->
            # jQuery EventeMitter:
            # http://james.padolsey.com/javascript/jquery-eventemitter/
            @_jq = $({})
            @opts = opts = @get_opts(options)

            unless opts.el
                throw new Error 'el cannot be empty.'
            @$el = $(opts.el)

            @before_render()
            opts.before_render.apply(@)
            @trigger('before_render')

            @render(opts.render_args).done (args...) =>
                @after_render([ args ])
                opts.after_render.apply(@, args)
                @trigger('after_render', [ args ])
                @init_events()
                opts.init_events.apply(@)

        render: (data) ->
            self = @
            def = $.Deferred()

            {
                $el, opts,
                opts: { tmpl, render_fn, datasource, data_filter }
            } = @

            render_tmpl = (tmpl) ->
                render = (data) ->
                    $tmpl = $(tmpl(_.isEmpty(data) and {} or data))
                    $el[render_fn]($tmpl)
                    if render_fn is 'replaceWith'
                        self.$el = $tmpl
                    def.resolve(data, $tmpl)

                if datasource
                    utils.api(datasource).done (data) ->
                        render data_filter(data)
                else
                    render _.isEmpty(data) and opts.data or data

            if tmpl
                if utils.is_template(tmpl)
                    render_tmpl tmpl
                else
                    require [
                        "text!#{tmpl}.html"
                    ], (tmpl) ->
                        render_tmpl _.template(tmpl)
            else
                def.resolve()

            def.promise()

        on: (args...) ->
            @_jq.on.apply(@_jq, args)
            @

        off: (args...) ->
            @_jq.off.apply(@_jq, args)
            @

        once: (args...) ->
            @_jq.one.apply(@_jq, args)
            @

        trigger: (args...) ->
            @_jq.trigger.apply(@_jq, args)
            @

        ###
        # 以下方法暴露给子类覆盖
        ###
        init_events: ->

        before_render: ->

        after_render: ->

    MuUI
