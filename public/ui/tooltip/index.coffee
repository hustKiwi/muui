define [
    'muui/core/base'
    'muui/lib/bootstrap/tooltip'
    'muui/lib/bootstrap/transition'
], (Base) ->
    class Tooltip extends Base
        @defaults:
            el: '.muui-show-tooltip'
            tooltipOptions:
                template: '<div class="muui-tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>'

        getOpts: (options) ->
            $.extend(true, {}, super(), Tooltip.defaults, options)

        beforeRender: ->
            @$el.tooltip(@opts.tooltipOptions)

        show: ->
            @$el.tooltip('show')

        hide: ->
            @$el.tooltip('hide')

        toggle: ->
            @$el.tooltip('toggle')

        destroy: ->
            @$el.off().tooltip('destroy')

    Tooltip
