define [
    'core/muui'
    'bower/tinycarousel/lib/jquery.tinycarousel'
], (MuUI) ->
    class Slider extends MuUI
        @defaults:
            el: '.muui-slider'
            item_cls: 'muui-slider-item'
            buttons_tmpl: '''
                <ul class="buttons">
                    <li class="arrow prev"></li>
                    <li class="arrow next"></li>
                </ul>
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
                interval: false
                animationTime: 300

        get_opts: (options) ->
            $.extend(true, {}, super(), Slider.defaults, options)

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

        init_events: ->
            $el = @$el
            $buttons = $el.find('.buttons')

            $el.on 'mouseenter', ->
                $buttons.fadeIn()
            .on 'mouseleave', ->
                $buttons.fadeOut()

            $buttons.on 'mouseenter', '.arrow', ->
                $(@).addClass('on')
            .on 'mouseleave', '.arrow', ->
                $(@).removeClass('on')

    Slider
