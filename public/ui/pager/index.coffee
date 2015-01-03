define [
    'muui/core/base'
], (Base) ->
    { ceil, floor } = Math

    class Pager extends Base
        @defaults:
            el: '.muui-pager'
            tmpl: _.template('''
                <% if (args.none) { %>
                <% } else { %>
                    <% var path = args.path; %>
                    <div class="muui-pager">
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
                    </div>
                <% } %>
            ''')
            handles:
                redirect: (e) ->

        get_opts: (options) ->
            $.extend(true, {}, super(), Pager.defaults, options)

        init_events: ->
            item_cls = 'muui-pager-item'
            handles = @opts.handles

            @$el.on 'mouseenter', "a.#{item_cls}:not(.on, .cur)", ->
                $(@).addClass('on')
            .on 'mouseleave', "a.#{item_cls}", ->
                $(@).removeClass('on')
            .on 'click', ".#{item_cls}", handles.redirect

        render: (data) ->
            data = @build(data)
            super(data and data or {
                args:
                    none: true
            })

        build: (data) ->
            _.defaults data, {
                path: ''
                size: 10
                length: 7
                prev_lable: '上一页'
                next_lable: '下一页'
            }
            { cur, total, size, length } = data

            if total <= size
                return null

            page_num = ceil(total / size)
            need_filter = false
            if page_num < length
                length = page_num
                need_filter = true

            cur = 1 unless 1 <= (cur = ~~cur) <= page_num

            if cur isnt 1
                has_prev = true
                data.prev = cur - 1

            if cur isnt page_num
                has_next = true
                data.next = cur + 1

            offset = floor((length - 1) / 2)
            if cur - offset < 1
                r = [1..length]
            else if cur + offset > page_num - 2
                r = [(page_num - length)..page_num]
            else
                r = [(cur - offset)..(cur + length - 1 - offset)]

            if r.length is 1
                return null
            else if length isnt 2
                if r[0] isnt 1
                    r[0] = 1
                    if r[1] isnt cur
                        r[1] = '...'

                l = r.length
                if r[l - 1] isnt page_num
                    r[l - 1] = page_num
                    r[l - 2] = '...'

                r[_.indexOf(r, cur)] = 'cur'
            else
                r.length = 0

            r.unshift(has_prev and 'prev' or 'prev_disabled')
            r.push(has_next and 'next' or 'next_disabled')

            if need_filter
                r = _.filter r, (item) ->
                    item isnt '...'

            {
                args: _.extend data, {
                    cur: cur
                    total: total
                    size: size
                    length: length
                }
                pager: r
            }

    Pager
