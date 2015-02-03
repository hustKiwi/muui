define [
    'muui/core/base'
], (Base) ->
    class Tab extends Base
        @defaults:
            el: '.muui-tab'
            tmpl: 'muui/tab/index'
            handles:
                change: ($item, $target) ->

        get_opts: (options) ->
            $.extend(true, {}, super(), Tab.defaults, options)

        init_events: ->
            item_cls = 'muui-tab-item'
            handles = @opts.handles

            @$el.on 'mouseenter', ".#{item_cls}:not(.on)", ->
                $(@).addClass('hover')
            .on 'mouseleave', ".#{item_cls}:not(.on)", ->
                $(@).removeClass('hover')
            .on 'click', ".#{item_cls}:not(.on)", ->
                $this = $(@)
                $target = $($this.data('target'))

                $this.siblings('.on').removeClass('on')
                    .end().removeClass('hover').addClass('on')
                $target.siblings('.on').removeClass('on')
                    .end().addClass('on')

                handles.change($this, $target)

                return false

    Tab
