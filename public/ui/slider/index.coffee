define [
    'core/muui'
    'bower/tinycarousel/lib/jquery.tinycarousel'
], (MuUI) ->
    class Slider extends MuUI
        @defaults:
            el: '.muui-slider'
            tinycarousel_options:
                interval: false
                animationTime: 300

        get_opts: (options) ->
            $.extend(true, {}, super(), Slider.defaults, options)

        after_render: ->
            @tinycarousel = @$el.tinycarousel(@opts.tinycarousel_options).data('plugin_tinycarousel')

        init_events: ->
            $el = @$el

            @once 'after_render', =>
                tinycarousel = @tinycarousel
                $arrows = $el.find('.arrows')

                $el.on 'mouseenter', ->
                    $arrows.fadeIn()
                .on 'mouseleave', ->
                    $arrows.fadeOut()

                $arrows.on 'mouseenter', '.arrow', ->
                    $(@).addClass('on')
                .on 'mouseleave', '.arrow', ->
                    $(@).removeClass('on')

    Slider
