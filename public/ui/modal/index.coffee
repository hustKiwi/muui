define [
    'core/muui'
    'core/utils'
    'bootstrap/modal'
    'bootstrap/transition'
], (MuUI, utils) ->
    $win = $(window)
    $doc = $(document)

    class Modal extends MuUI
        @defaults:
            el: '.muui-modal'
            tmpl: _.template('''
                <div class="muui-modal-dialog modal-dialog">
                    <div class="muui-modal-header">
                        <% if (title) { %>
                            <h3><%= title %></h3>
                        <% } %>
                        <% if (btns.close) { %>
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                        <% } %>
                    </div>
                    <div class="muui-modal-body"><%= body %></div>
                    <div class="muui-modal-footer">
                        <% if (btns.submit) { %>
                            <button class="btn btn-primary submit" data-dismiss="modal" aria-hidden="true">提交</button>
                        <% } %>
                        <% if (btns.cancel) { %>
                            <button class="btn" data-dismiss="modal" aria-hidden="true">取消</button>
                        <% } %>
                        <%= footer %>
                    </div>
                </div>
            ''')
            data:
                title: ''
                btns:
                    close: true
                    submit: true
                    cancel: true
                body: ''
                footer: ''
            render_fn: 'html'
            offset_top: -120
            offset_left: 0
            modal_options:
                backdrop: 'static'

        get_opts: (options) ->
            $.extend(true, {}, super(), Modal.defaults, options)

        init_events: ->
            $el = @$el
            $el.on 'show.bs.modal', =>
                $el.css {
                    marginTop: @_calc_top() + (utils.is_ie6() and $doc.scrollTop() or 0)
                    marginLeft: @_calc_left()
                }

        after_render: ->
            @$el.modal(@opts.modal_options)
            @modal = @$el.data('bs.modal')
            @modal.$backdrop.addClass('muui-modal-backdrop')

        _calc_top: ->
            offset_top = @opts.offset_top
            if _.isFunction offset_top
                offset_top = offset_top.call(@)
            - (@$el.height() / 2 - (offset_top or 0))

        _calc_left: ->
            offset_left = @opts.offset_left
            if _.isFunction offset_left
                offset_left = offset_left.call(@)
            - (@$el.width() / 2 - (offset_left or 0))

    Modal
