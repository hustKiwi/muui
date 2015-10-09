define [
    'muui/core/base'
    'muui/lib/bootstrap/button'
], (Base) ->
    class Button extends Base
        @defaults:
            el: '.muui-btn'
            buttonOptions:
                loadingText: 'loading...'

        getOpts: (options) ->
            $.extend(true, {}, super(), Button.defaults, options)

        afterRender: ->
            @$el.button(@opts.tooltipOptions)
