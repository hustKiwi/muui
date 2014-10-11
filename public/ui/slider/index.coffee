define [
    'core/muui'
    'bower/unslider/src/unslider'
], (MuUI) ->
    class Slider extends MuUI
        @defaults:
            el: '.muui-slider'
            unslider:
                items: '.muui-slider-items'
                item: '.muui-slider-item'
                speed: 300
                dots: true
                arrows: true
                autoplay: false

        get_opts: (options) ->
            $.extend(true, {}, super(), Slider.defaults, options)

        after_render: ->
            @unslider = @$el.unslider(@opts.unslider).data('unslider')

        init_events: ->
            $el = @$el
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
