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
            @tooltip = @$el.tooltip(@opts.tooltip_options).data('bs.tooltip')

        show: ->
            @tooltip.tooltip('show')

        hide: ->
            @tooltip.tooltip('hide')

        toggle: ->
            @tooltip.tooltip('toggle')

        destroy: ->
            @$el.off()
            @tooltip.tooltip('destroy')

    Tooltip
