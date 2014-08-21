module.exports =
    init: (app) ->
        datasource = require './datasource/index'
        app.get '/datasource/tab', datasource.tab

        for name in [
            'tab'
            'webapp_tab'
        ]
            do (name) ->
                app.get "/#{name}", (req, res) ->
                    res.render "ui/#{name}"
