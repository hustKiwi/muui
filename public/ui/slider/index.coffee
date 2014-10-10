define [
    'core/muui'
    'bower/unslider/src/unslider'
], (MuUI) ->
    class Slider extends MuUI
        defaults:
            el: '.muui-pager'

        get_opts: (options) ->
            $.extend({}, super(), Slider.defaults, options)

        after_render: ->

    Slider
