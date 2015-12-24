define [
    'muui/core/base'
], (Base) ->
    { ceil, floor } = Math

    class Pager extends Base
        @defaults:
            el: '.muui-pager'
            renderFn: 'html'
            tmpl: _.template('''
                <% if (!_.isEmpty(args)) { %>
                    <% var path = args.path; %>
                    <% _.each(pager, function(item) { %>
                        <% if (item === 'prev') { %>
                            <a class="muui-pager-prev muui-pager-item"
                                data-page="<%- args.prev %>"
                                href="<%- path.replace(/{page}/g, args.prev) %>">
                                <%- args.prevLabel %>
                            </a>
                        <% } else if (item === 'prevDisabled') { %>
                            <span class="muui-pager-prev muui-pager-disabled muui-pager-item">
                                <%- args.prevLabel %>
                            </span>
                        <% } else if (item === 'next') { %>
                            <a class="muui-pager-next muui-pager-item"
                                data-page="<%- args.next %>"
                                href="<%- path.replace(/{page}/g, args.next) %>">
                                <%- args.nextLabel %>
                            </a>
                        <% } else if (item === 'nextDisabled') { %>
                            <span class="muui-pager-next muui-pager-disabled muui-pager-item">
                                <%- args.nextLabel %>
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

        getOpts: (options) ->
            $.extend(true, {}, super(), Pager.defaults, options)

        initEvents: ->
            itemCls = 'muui-pager-item'
            handles = @opts.handles

            @$el.on 'mouseenter', "a.#{itemCls}:not(.on, .cur)", ->
                $(@).addClass('on')
            .on 'mouseleave', "a.#{itemCls}", ->
                $(@).removeClass('on')
            .on 'click', "a.#{itemCls}", handles.redirect

        beforeRender: ->
            @$el.addClass('loading')

        afterRender: ->
            @$el.removeClass('loading')

        render: (data) ->
            data = _.extend @$el.data('pager'), data
            super @build(data) or {
                args: null
            }

        build: (data) ->
            data = _.extend {
                path: '?page={page}'
                size: 10
                length: 7
                prevLabel: '上一页'
                nextLabel: '下一页'
            }, data
            { cur, total, size, length } = data

            if total <= size
                return null

            pageNum = ceil(total / size)
            canFill = false
            if pageNum < length
                length = pageNum
                canFill = true

            cur = 1 unless 1 <= (cur = ~~cur) <= pageNum

            if cur isnt 1
                hasPrev = true
                data.prev = cur - 1

            if cur isnt pageNum
                hasNext = true
                data.next = cur + 1

            if canFill
                r = [1..pageNum]
            else
                offset = floor((length - 1) / 2)
                if cur - offset < 1
                    r = [1..length]
                else if cur + offset > pageNum - 2
                    r = [(pageNum - length)..pageNum]
                else
                    r = [(cur - offset)..(cur + length - 1 - offset)]

            if r.length is 1
                return null
            else if not canFill
                if r[0] isnt 1
                    r[0] = 1
                    if r[1] isnt cur
                        r[1] = '...'

                l = r.length
                if r[l - 1] isnt pageNum
                    r[l - 1] = pageNum
                    r[l - 2] = '...'

            r[_.indexOf(r, cur)] = 'cur'
            r.unshift(hasPrev and 'prev' or 'prevDisabled')
            r.push(hasNext and 'next' or 'nextDisabled')

            {
                args: _.merge data, {
                    cur: cur
                    total: total
                    size: size
                    length: length
                }
                pager: r
            }
