define [
    'muui/core/base'
    'muui/lib/tinycarousel/jquery.tinycarousel'
], (Base) ->
    class Slider extends Base
        @defaults:
            el: '.muui-slider'
            itemCls: 'muui-slider-item'
            buttonsTmpl: '''
                    <a href="#" class="arrow prev"></a>
                    <a href="#" class="arrow next"></a>
            '''
            bulletsTmpl: '''
                <ol class="bullets">
                <% for (var i = 0; i < total; i++) { %>
                    <li class="bullet<%- i === cur ? ' active': '' %>" data-slide="<%- i %>">
                        <%- i + 1 %>
                    </li>
                <% } %>
                </ol>
            '''

            tinycarouselOptions:
                buttons: true
                bullets: true
                interval: true
                animationTime: 500

        getOpts: (options) ->
            $.extend(true, {}, super(), Slider.defaults, options)

        initEvents: ->
            { $el, tinycarousel } = @
            $arrow = $el.find('.arrow')

            $el.on 'mouseenter', ->
                $arrow.fadeIn()
                tinycarousel.stop()
            .on 'mouseleave', ->
                $arrow.fadeOut()
                tinycarousel.start()

            $el.on 'mouseenter', '.arrow', ->
                $(@).addClass('on')
            .on 'mouseleave', '.arrow', ->
                $(@).removeClass('on')

        beforeRender: ->
            { $el, opts, opts: { tinycarouselOptions } } = @
            @$items = $items = $el.find('.' + opts.itemCls)

            if tinycarouselOptions.buttons
                $el.append $(opts.buttonsTmpl)

            if tinycarouselOptions.bullets
                $el.append $(_.template(opts.bulletsTmpl)({
                    cur: tinycarouselOptions.start
                    total: $items.length
                }))

        afterRender: ->
            tinycarousel = @$el.tinycarousel(@opts.tinycarouselOptions).data('plugin_tinycarousel')

            @$el.on 'move', (e, $cur, cur) =>
                @trigger('move', $cur, cur)

            for fn in _.functions(tinycarousel)
                @[fn] = tinycarousel[fn]

            @tinycarousel = tinycarousel

        prev: ->
            { tinycarousel, tinycarousel: { slideCurrent, slidesTotal } } = @
            if slideCurrent is 0
                tinycarousel.move(slidesTotal - 1)
            else
                tinycarousel.move(slideCurrent- 1)

        next: ->
            { tinycarousel } = @
            tinycarousel.move (tinycarousel.slideCurrent + 1) % tinycarousel.slidesTotal

