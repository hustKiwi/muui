define [
    'muui/core/base'
    'muui/lib/bootstrap/button'
], (Base) ->
    class Button extends Base
        @defaults:
            el: '.muui-btn'
            button_options:
                loadingText: 'loading...'

        get_opts: (options) ->
            _.merge(super(), _.clone(Button.defaults), options)

        after_render: ->
            @$el.button(@opts.tooltip_options)

    Button
