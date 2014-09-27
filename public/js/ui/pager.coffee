define [
    'muui/ui/muui'
], (MuUI) ->
    { ceil, floor } = Math

    class Pager extends MuUI
        @defaults:
            el: '.muui-pager'
            tmpl: _.template("""
                <% var path = args.path; %>
                <div class="muui-pager">
                <% _.each(pager, function(item) { %>
                    <% if (item === 'prev') { %>
                        <a class="muui-pager-prev muui-pager-item"
                            data-page="<%- args.prev %>"
                            href="<%- path.replace(/{page}/g, args.prev) %>">
                            <%- args.prev_lable %>
                        </a>
                    <% } else if (item === 'next') { %>
                        <a class="muui-pager-next muui-pager-item"
                            data-page="<%- args.next %>"
                            href="<%- path.replace(/{page}/g, args.next) %>">
                            <%- args.next_lable %>
                        </a>
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
            """)
            handles:
                redirect: (e) ->

        get_opts: (options) ->
            $.extend({}, Pager.defaults, super(options))

        init_events: ->
            item_cls = 'muui-pager-item'
            handles = @opts.handles

            @$el.on 'mouseenter', ".#{item_cls}:not(.on, .cur)", ->
                $(@).addClass('on')
            .on 'mouseleave', ".#{item_cls}", ->
                $(@).removeClass('on')
            .on 'click', ".#{item_cls}", handles.redirect

        render: (args) ->
            { opts } = @
            {
                before_render, after_render
                render_fn, tmpl
            } = opts
            @$el = $el = $(opts.el)

            before_render()
            def = $.Deferred()

            do (r = @build(args)) =>
                done = (r) ->
                    def.resolve(r)
                    after_render(r)

                return done(r) unless r.pager.length

                if _.isString(tmpl)
                    tmpl = _.template(tmpl)

                $tmpl = $(tmpl(r))
                $el[render_fn]($tmpl)
                if render_fn is 'replaceWith'
                    @$el = $tmpl

                done(r)

            def.promise()

        build: (data) ->
            _.defaults data, {
                path: ''
                size: 10
                length: 7
                prev_lable: '上一页'
                next_lable: '下一页'
            }
            { cur, total, size, length } = data

            page_num = ceil(total / size)
            if page_num < length
                length = page_num

            cur = 1 unless 1 <= (cur = ~~cur) <= page_num

            if cur isnt 1
                has_prev = true
                data.prev = cur - 1

            if cur isnt page_num
                has_next = true
                data.next = cur + 1

            if cur - length < 1
                r = [1..length]
            else if cur + length > page_num
                r = [(page_num - length + 1)..page_num]
            else
                offset = floor((length - 1) / 2)
                if cur - offset < 1
                    offset = cur - 1

                r = (i for i in [(cur - offset)..(cur + length - 1 - offset)])

            return [] if r.length is 1

            if r[0] isnt 1
                r[0] = 1
                if r[1] isnt cur
                    r[1] = '...'

            l = r.length
            if r[l - 1] isnt page_num
                r[l - 1] = page_num
                r[l - 2] = '...'

            r[_.indexOf(r, cur)] = 'cur'

            r.unshift('prev') if has_prev
            r.push('next') if has_next

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
