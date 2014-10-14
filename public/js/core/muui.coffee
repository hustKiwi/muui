define [
    'core/utils'
], (utils) ->
    $html = $('html')

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
                @init_events()
                @after_render([ args ])
                opts.after_render([ args ])

        render: (data) ->
            self = @
            { $el, opts } = @

            # 检查之前的$el是否还存在
            # Ajax时$el可能被从页面移除，例如对Pager的使用
            unless $html.has($el).length
                @$el = $el = $(opts.el)

            { tmpl, render_fn, datasource, data_filter } = opts

            def = $.Deferred()

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

        ###
        # 以下方法暴露给子类覆盖
        ###
        init_events: ->

        before_render: ->

        after_render: ->

    MuUI
