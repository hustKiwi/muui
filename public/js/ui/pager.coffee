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
            console.log 'init_events'

    Pager
