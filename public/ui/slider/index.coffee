define [
    'muui/core/base'
    'muui/lib/tinycarousel/jquery.tinycarousel'
], (Base) ->
    class Slider extends Base
        @defaults:
            el: '.muui-slider'
            item_cls: 'muui-slider-item'
            buttons_tmpl: '''
                    <a href="#" class="arrow prev"></a>
                    <a href="#" class="arrow next"></a>
            '''
            bullets_tmpl: '''
                <ol class="bullets">
                <% for (var i = 0; i < total; i++) { %>
                    <li class="bullet<%- i === cur ? ' active': '' %>" data-slide="<%- i %>">
                        <%- i + 1 %>
                    </li>
                <% } %>
                </ol>
            '''

            tinycarousel_options:
                buttons: true
                bullets: true
                interval: true
                animationTime: 300

        get_opts: (options) ->
            _.merge(super(), _.clone(Slider.defaults), options)

        init_events: ->
            $el = @$el
            $arrow = $el.find('.arrow')

            $el.on 'mouseenter', ->
                $arrow.fadeIn()
            .on 'mouseleave', ->
                $arrow.fadeOut()

            $el.on 'mouseenter', '.arrow', ->
                $(@).addClass('on')
            .on 'mouseleave', '.arrow', ->
                $(@).removeClass('on')

        before_render: ->
            { $el, opts, opts: { tinycarousel_options } } = @
            @$items = $items = $el.find('.' + opts.item_cls)

            if tinycarousel_options.buttons
                $el.append $(opts.buttons_tmpl)

            if tinycarousel_options.bullets
                $el.append $(_.template(opts.bullets_tmpl, {
                    cur: tinycarousel_options.start
                    total: $items.length
                }))

        after_render: ->
            @tinycarousel = @$el.tinycarousel(@opts.tinycarousel_options).data('plugin_tinycarousel')

    Slider
