define [
    'muui/core/base'
    'muui/core/utils'
    'muui/lib/bootstrap/modal'
    'muui/lib/bootstrap/transition'
], (Base, utils) ->
    $body = $('body')

    class Modal extends Base
        @defaults:
            container: '<div class="muui-modal fade" tabindex="-1" style="display: none;"></div>',
            tmpl: _.template('''
                <div class="muui-modal-stick"></div>
                <div class="<%- cls && cls + ' ' || '' %>muui-modal-dialog modal-dialog<%- title ? '' : ' without-title' %>">
                    <div class="muui-modal-header">
                        <h3><%= title %></h3>
                        <% if (btns.close) { %>
                            <a class="close" data-dismiss="modal" aria-hidden="true" href="javascript:;">×</a>
                        <% } %>
                    </div>
                    <div class="muui-modal-body"><%= body %></div>
                    <div class="muui-modal-footer">
                        <% if (_.isEmpty(footer)) { %>
                            <% if (btns.submit) { %>
                                <button class="muui-btn muui-btn-primary submit" data-dismiss="modal" aria-hidden="true">确定</button>
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
            loadingTmpl: '''
                <div class="loading-panel">
                    <i class="ui-loading"></i>
                    <p class="tip">
                        正在加载，请稍候 ...
                    </p>
                </div>
            '''
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
            { $el } = @
            $el.off().on 'click', '.muui-modal-footer .muui-btn', ->
                $(@).blur()
            .on 'show.bs.modal, hide.bs.modal', ->
                $el.removeClass('muui-modal-loading')

        beforeRender: ->
            @$el = $(@opts.container).appendTo($body)

        afterRender: ->
            @modal = @$el.modal(@opts.modalOptions)
                .removeClass('muui-modal-loading').data('bs.modal')

        show: ->
            @modal.show()
            @

        hide: ->
            @modal.hide()
            @

        toggle: ->
            @modal.toggle()
            @

        loading: ->
            @setModalBody(@opts.loadingTmpl)
                .$el.addClass('muui-modal-loading')
            @

        setModalBody: (html) ->
            { $el, opts } = @
            $el.find('.muui-modal-body').html(html)
            if html isnt opts.loadingTmpl
                $el.removeClass('muui-modal-loading')
            @

        setTitle: (title) ->
            @$el.removeClass('without-title')
                .find('.muui-modal-header h3').text(title)
            @

    for item in ['header', 'footer']
        do (item) ->
            Modal::["setModal#{_.capitalize(item)}"] = (html) ->
                @$el.find(".muui-modal-#{item}").html(html)
                @

    Modal
