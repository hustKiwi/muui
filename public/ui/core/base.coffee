define [
    'muui/core/utils'
    'muui/lib/eventEmitter/eventEmitter'
], (utils, EventEmitter) ->
    class MuUI
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
            @_ee = new EventEmitter
            @opts = opts = @getOpts(options)

            unless opts.el
                throw new Error 'el cannot be empty.'
            @$el = $(opts.el)

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

        on: (args...) ->
            @_ee.on.apply(@_ee, args)
            @

        off: (args...) ->
            @_ee.off.apply(@_ee, args)
            @

        once: (args...) ->
            @_ee.one.apply(@_ee, args)
            @

        trigger: (args...) ->
            @_ee.trigger.apply(@_ee, args)
            @

        ###
        # 以下方法暴露给子类覆盖
        ###
        initEvents: ->

        beforeRender: ->

        afterRender: ->

    MuUI
