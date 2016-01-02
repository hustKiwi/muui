define [
    'muui/core/utils'
    'muui/core/event_emitter'
], (utils, EventEmitter) ->
    class MuUI extends EventEmitter
        @defaults:
            el: ''
            dataSource: ''
            renderArgs: {}
            renderFn: 'replaceWith'
            dataFilter: (r) ->
                r
            beforeRender: ->
            afterRender: ->
            initEvents: ->

        getOpts: ->
            MuUI.defaults

        constructor: (options) ->
            @opts = opts = @getOpts(options)
            @$el = $(opts.el).off()

            super()
            @beforeRender()
            opts.beforeRender.apply(@)
            @trigger('beforeRender')

            @render(opts.renderArgs).done (args...) =>
                @afterRender([ args ])
                opts.afterRender.apply(@, args)
                @trigger('afterRender', [ args ]).initEvents()
                opts.initEvents.apply(@)

        render: (renderArgs) ->
            self = @
            def = $.Deferred()

            {
                $el, opts, opts: {
                    tmpl, renderFn, dataSource, dataFilter
                }
            } = @

            renderTmpl = (tmpl) ->
                render = (data) ->
                    $tmpl = $(tmpl(_.isEmpty(data) and {} or data))
                    $el[renderFn]($tmpl)
                    if renderFn is 'replaceWith'
                        self.$el = $tmpl
                    def.resolve(data, $tmpl)

                if dataSource
                    utils.api(dataSource).done (data) ->
                        render dataFilter(data)
                else
                    render renderArgs

            if tmpl
                if utils.isTemplate(tmpl)
                    renderTmpl tmpl
                else
                    require [
                        "text!#{tmpl}.html"
                    ], (tmpl) ->
                        renderTmpl _.template(tmpl)
            else
                def.resolve()

            def.promise()

        ###
        # 以下方法暴露给子类覆盖
        ###
        initEvents: ->

        beforeRender: ->

        afterRender: ->
