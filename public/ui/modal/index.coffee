define [
    'core/muui'
    'bootstrap/modal'
    'bootstrap/transition'
], (MuUI) ->
    class Modal extends MuUI
        @defaults:
            el: '.muui-modal'
            tmpl: 'muui/modal/index'
            render_fn: 'html'
            modal:
                backdrop: 'static'

        get_opts: (options) ->
            $.extend(true, {}, super(), Modal.defaults, options)

        after_render: ->
            @$el.modal(@opts.modal)

    Modal
