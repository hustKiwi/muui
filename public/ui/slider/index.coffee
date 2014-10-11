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
                autoplay: false

        get_opts: (options) ->
            $.extend(true, {}, super(), Slider.defaults, options)

        after_render: ->
            @unslider = @$el.unslider(@opts.unslider).data('unslider')

        init_events: ->
            { $el, opts, unslider } = @

            $wrap = $el.parents('.muui-slider-wrap')
            if $wrap.length
                $el = $wrap

            $el.on 'mouseenter', ->
                $arrows.fadeIn()
            .on 'mouseleave', ->
                $arrows.fadeOut()

            $arrows = $wrap.find('.arrows')
            $arrows.on 'mouseenter', '.arrow', ->
                $(@).addClass('on')
            .on 'mouseleave', '.arrow', ->
                $(@).removeClass('on')

            unless opts.unslider.arrows
                $arrows.on 'click', '.prev', ->
                    unslider.prev()
                $arrows.on 'click', '.next', ->
                    unslider.next()

    Slider
