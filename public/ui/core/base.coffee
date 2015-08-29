define [
    'muui/core/utils'
], (utils) ->
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
            # jQuery EventeMitter:
            # http://james.padolsey.com/javascript/jquery-eventemitter/
            @_jq = $({})
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
                @trigger('afterRender', [ args ])
                @initEvents()
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
        initEvents: ->

        beforeRender: ->

        afterRender: ->

    MuUI
