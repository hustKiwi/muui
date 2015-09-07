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
            $el.on 'click', '.muui-modal-footer .muui-btn', ->
                $(@).blur()
            .on 'hide.bs.modal', ->
                $el.empty()

        beforeRender: ->
            unless @$el.length
                @$el = $(@opts.container).appendTo($body)

        afterRender: ->
            @modal = @$el.modal(@opts.modalOptions).data('bs.modal')

        show: ->
            @render(@opts.renderArgs).done =>
                @$el.modal('show')
            @

        hide: ->
            @$el.modal('hide')
            @

        toggle: ->
            @$el.modal('toggle')
            @

        loading: ->
            @setModalBody(@opts.loadingTmpl)
                .$el.addClass('muui-modal-loading')

        setModalBody: (html) ->
            { $el, opts } = @
            $el.find('.muui-modal-body').html(html)
            if html isnt opts.loadingTmpl
                $el.removeClass('muui-modal-loading')
            @

    for item in ['header', 'footer']
        do (item) ->
            Modal::["setModal#{_.capitalize(item)}"] = (html) ->
                @$el.find(".muui-modal-#{item}").html(html)
                @

    Modal
