module.exports =
    init: (app) ->
        datasource = require './datasource/index'
        app.get '/datasource/tab', datasource.tab

        app.get '/tab', (req, res) ->
            res.render 'ui/tab'
