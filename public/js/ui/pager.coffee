define [
    'muui/ui/muui'
], (MuUI) ->
    ceil = Math.ceil

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

        build: (cur, total, size, length = 7) ->
            page_num = ceil(total / size)
            if page_num < length
                length = page_num

            cur = 1 unless 1 <= (cur = ~~cur) <= page_num

            if cur isnt 1
                has_prev = true

            if cur isnt page_num
                has_next = true

            offset = ceil((length - 1) / 2)
            if cur - offset < 1
                offset = cur - 1

            r = (i for i in [(cur - offset)..(cur + length - offset)])
            console.log r

            if r[0] isnt 1
                r[0] = 1
                if r[1] isnt cur
                    r[1] = '...'

            l = r.length
            if r[l - 1] isnt page_num
                r[l - 1] = page_num
                r[l - 2] = '...'

            r[_.indexOf(r, cur)] = '*'

            r.unshift('prev') if has_prev
            r.push('next') if has_next

            r

    Pager
