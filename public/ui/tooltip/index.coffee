define [
    'muui/core/base'
    'muui/lib/bootstrap/tooltip'
    'muui/lib/bootstrap/transition'
], (Base) ->
    class Tooltip extends Base
        @defaults:
            el: '.muui-show-tooltip'
            tooltip_options:
                template: '<div class="muui-tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>'

        get_opts: (options) ->
            $.extend(true, {}, super(), Tooltip.defaults, options)

        before_render: ->
            @$el.tooltip(@opts.tooltip_options)

        show: ->
            @$el.tooltip('show')

        hide: ->
            @$el.tooltip('hide')

        toggle: ->
            @$el.tooltip('toggle')

        destroy: ->
            @$el.off().tooltip('destroy')

    Tooltip
