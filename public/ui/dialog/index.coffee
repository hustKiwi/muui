define [
    'core/muui'
    'bootstrap/modal'
    'bootstrap/transition'
], (MuUI) ->
    class Dialog extends MuUI
        @defaults:
            el: '.muui-dialog'
            tmpl: 'muui/dialog/index'
            render_fn: 'html'
            modal:
                backdrop: 'static'

        get_opts: (options) ->
            $.extend(true, {}, super(), Dialog.defaults, options)

        after_render: ->
            @$el.modal(@opts.modal)

    Dialog
