define [
    'muui/ui/muui'
], (MuUI) ->
    class Pager extends MuUI
        @defaults:
            el: '.muui-pager'
            tmpl: 'tmpl/pager'
            handles:
                change: ($item, $target) ->

        get_opts: (options) ->
            $.extend({}, Pager.defaults, super(options))

        init_events: ->
            item_cls = 'muui-pager-item'
            handles = @opts.handles

            @$el.on 'mouseenter', ".#{item_cls}:not(.on, .cur)", ->
                $(@).addClass('on')
            .on 'mouseleave', ".#{item_cls}", ->
                $(@).removeClass('on')

    Pager
