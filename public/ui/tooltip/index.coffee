define [
    'core/muui'
    'bootstrap/tooltip'
], (MuUI) ->
    class Tooltip extends MuUI
        @defaults:
            tooltip_options:
                template: '<div class="muui-tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>'

        get_opts: (options) ->
            $.extend(true, {}, super(), Tooltip.defaults, options)

        after_render: ->
            @tooltip = @$el.tooltip(@opts.tooltip_options).data('bs.tooltip')

        show: ->
            @$el.modal('show')

        hide: ->
            @$el.modal('hide')

        toggle: ->
            @$el.modal('toggle')

        destroy: ->
            @$el.modal('destroy')

    Tooltip
