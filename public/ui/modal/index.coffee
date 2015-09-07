define [
    'muui/core/base'
    'muui/core/utils'
    'muui/lib/bootstrap/modal'
    'muui/lib/bootstrap/transition'
], (Base, utils) ->
    $doc = $(document)
    $body = $('body')

    class Modal extends Base
        @defaults:
            el: '.muui-modal'
            container: '<div class="muui-modal fade" tabindex="-1" style="display: none;"></div>'
            tmpl: _.template('''
                <div class="muui-modal-stick"></div>
                <div class="<%- cls && cls + ' ' || '' %>muui-modal-dialog modal-dialog">
                    <div class="muui-modal-header">
                        <% if (title) { %>
                            <h3><%= title %></h3>
                        <% } %>
                        <% if (btns.close) { %>
                            <span class="close" data-dismiss="modal" aria-hidden="true">×</span>
                        <% } %>
                    </div>
                    <div class="muui-modal-body"><%= body %></div>
                    <div class="muui-modal-footer">
                        <% if (_.isEmpty(footer)) { %>
                            <% if (btns.submit) { %>
                                <button class="muui-btn muui-btn-primary submit" data-dismiss="modal" aria-hidden="true">确定
                            <% } %>
                            <% if (btns.cancel) { %>
                                <button class="muui-btn" data-dismiss="modal" aria-hidden="true">取消</button>
                            <% } %>
                        <% } else { %>
                            <%= footer %>
                        <% } %>
                    </div>
                </div>
            ''')
            renderArgs:
                title: ''
                cls: ''
                btns:
                    close: true
                    submit: true
                    cancel: true
                body: ''
                footer: ''
            renderFn: 'html'
            modalOptions:
                show: false
                backdrop: true

        getOpts: (options) ->
            $.extend(true, {}, super(), Modal.defaults, options)

        initEvents: ->
            @$el.on 'click', '.muui-modal-footer .muui-btn', ->
                $(@).blur()

        beforeRender: ->
            unless @$el.length
                @$el = $(@opts.container).appendTo($body)

        afterRender: ->
            @modal = @$el.modal(@opts.modalOptions).data('bs.modal')

        show: ->
            @$el.modal('show')

        hide: ->
            @$el.modal('hide')

        toggle: ->
            @$el.modal('toggle')

    for item in ['header', 'body', 'footer']
        do (item) ->
            Modal::["setModal#{_.capitalize(item)}"] = (html) ->
                @$el.find(".muui-modal-#{item}").html(html)

    Modal
