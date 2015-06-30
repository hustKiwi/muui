define [
    'muui/core/base'
], (Base) ->
    { ceil, floor } = Math

    class Pager extends Base
        @defaults:
            el: '.muui-pager'
            render_fn: 'html'
            tmpl: _.template('''
                <% if (args.none) { %>
                <% } else { %>
                    <% var path = args.path; %>
                    <% _.each(pager, function(item) { %>
                        <% if (item === 'prev') { %>
                            <a class="muui-pager-prev muui-pager-item"
                                data-page="<%- args.prev %>"
                                href="<%- path.replace(/{page}/g, args.prev) %>">
                                <%- args.prev_lable %>
                            </a>
                        <% } else if (item === 'prev_disabled') { %>
                            <span class="muui-pager-prev muui-pager-disabled muui-pager-item">
                                <%- args.prev_lable %>
                            </span>
                        <% } else if (item === 'next') { %>
                            <a class="muui-pager-next muui-pager-item"
                                data-page="<%- args.next %>"
                                href="<%- path.replace(/{page}/g, args.next) %>">
                                <%- args.next_lable %>
                            </a>
                        <% } else if (item === 'next_disabled') { %>
                            <span class="muui-pager-next muui-pager-disabled muui-pager-item">
                                <%- args.next_lable %>
                            </span>
                        <% } else if (item === 'cur') { %>
                            <span class="muui-pager-item cur"><%- args.cur %></span>
                        <% } else if (item === '...') { %>
                            <span class="muui-pager-ellipse">...</span>
                        <% } else { %>
                            <a class="muui-pager-item"
                                data-page="<%- item %>"
                                href="<%- path.replace(/{page}/g, item) %>">
                                <%- item %>
                            </a>
                        <% } %>
                    <% }); %>
                <% } %>
            ''')
            handles:
                redirect: ->

        get_opts: (options) ->
            $.extend(true, {}, super(), Pager.defaults, options)

        init_events: ->
            item_cls = 'muui-pager-item'
            handles = @opts.handles

            @$el.on 'mouseenter', "a.#{item_cls}:not(.on, .cur)", ->
                $(@).addClass('on')
            .on 'mouseleave', "a.#{item_cls}", ->
                $(@).removeClass('on')
            .on 'click', "a.#{item_cls}", handles.redirect

        render: (data) ->
            data = @build(data)
            super(data and data or {
                args:
                    none: true
            })

        build: (data) ->
            _.defaults data, {
                path: '?page={page}'
                size: 10
                length: 7
                prev_lable: '上一页'
                next_lable: '下一页'
            }
            { cur, total, size, length } = data

            if total <= size
                return null

            page_num = ceil(total / size)
            can_fill = false
            if page_num < length
                length = page_num
                can_fill = true

            cur = 1 unless 1 <= (cur = ~~cur) <= page_num

            if cur isnt 1
                has_prev = true
                data.prev = cur - 1

            if cur isnt page_num
                has_next = true
                data.next = cur + 1

            if can_fill
                r = [1..page_num]
            else
                offset = floor((length - 1) / 2)
                if cur - offset < 1
                    r = [1..length]
                else if cur + offset > page_num - 2
                    r = [(page_num - length)..page_num]
                else
                    r = [(cur - offset)..(cur + length - 1 - offset)]

            if r.length is 1
                return null
            else
                if r[0] isnt 1
                    r[0] = 1
                    if r[1] isnt cur
                        r[1] = '...'

                l = r.length
                if r[l - 1] isnt page_num
                    r[l - 1] = page_num
                    r[l - 2] = '...'

                r[_.indexOf(r, cur)] = 'cur'

            r.unshift(has_prev and 'prev' or 'prev_disabled')
            r.push(has_next and 'next' or 'next_disabled')

            {
                args: _.merge data, {
                    cur: cur
                    total: total
                    size: size
                    length: length
                }
                pager: r
            }

    Pager
