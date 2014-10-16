define [
    'core/muui'
    'bootstrap/modal'
], (MuUI) ->
    class Tooltip extends MuUI
        @defaults:
            el: '.muui-tooltip'

        get_opts: (options) ->
            $.extend(true, {}, super(), Tooltip.defaults, options)

        init_events: ->

    Tooltip
