define [
    'muui/core/base'
], (Base) ->
    class Tab extends Base
        @defaults:
            el: '.muui-tab'
            tmpl: 'muui/tab/index'
            handles:
                change: ($item, $target) ->

        getOpts: (options) ->
            $.extend(true, {}, super(), Tab.defaults, options)

        initEvents: ->
            itemCls = 'muui-tab-item'
            handles = @opts.handles

            @$el.on 'mouseenter', ".#{itemCls}:not(.on)", ->
                $(@).addClass('hover')
            .on 'mouseleave', ".#{itemCls}:not(.on)", ->
                $(@).removeClass('hover')
            .on 'click', ".#{itemCls}:not(.on)", ->
                $this = $(@)
                $target = $($this.data('target'))

                $this.siblings('.on').removeClass('on')
                    .end().removeClass('hover').addClass('on')
                $target.siblings('.on').removeClass('on')
                    .end().addClass('on')

                handles.change($this, $target)

                return false

    Tab
