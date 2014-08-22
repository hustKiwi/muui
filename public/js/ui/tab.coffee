define [
    'ui/muui'
], (MuUI) ->
    class Tab extends MuUI
        @defaults:
            tmpl: 'tmpl/tab'
            handles:
                change: ($item, $target) ->

        get_opts: (options) ->
            $.extend({}, Tab.defaults, super(options))

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
