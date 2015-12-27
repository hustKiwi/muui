define [
    'muui/core/base'
], (Base) ->
    class Tab extends Base
        @defaults:
            el: '.muui-tab'
            tmpl: 'muui/tab/index'
            itemCls: 'muui-tab-item'
            handles:
                change: ($item, $target) ->

        getOpts: (options) ->
            $.extend(true, {}, super(), Tab.defaults, options)

        initEvents: ->
            self = @
            { itemCls, handles } = @opts

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
                self.trigger('tab:change', $this, $target)

                false
