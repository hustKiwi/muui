define [
    'ui/muui'
], (MuUI) ->
    class Tab extends MuUI
        @defaults:
            tmpl: 'tmpl/tab'

        get_opts: (options) ->
            $.extend({}, Tab.defaults, super(options))

        init_events: ->
            @$el.on 'mouseenter', '.nav-item:not(.on)', ->
                $(@).addClass('hover')
            .on 'mouseleave', '.nav-item:not(.on)', ->
                $(@).removeClass('hover')
            .on 'click', '.nav-item:not(.on)', ->
                $this = $(@)
                $this.siblings('.on').removeClass('on').end()
                    .removeClass('hover').addClass('on')
                $($this.data('target')).siblings('.on').removeClass('on')
                    .end().addClass('on')
                return false

    Tab
