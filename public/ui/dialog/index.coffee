define [
    'core/muui'
], (MuUI) ->
    class Dialog extends MuUI
        @defaults:
            el: '.muui-dialog'

        get_opts: (options) ->
            $.extend(true, {}, super(), Tab.defaults, options)

    Dialog
