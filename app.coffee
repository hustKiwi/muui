fs = require 'fs'
express = require 'express'

class App
    constructor: (port) ->
        @port = port
        @init_app()
        @init_routers()
        @start_server()

    init_app: ->
        @app = app = express()

        app.disable('x-powered-by')
        app.engine('jade', require('jade').__express);
        app.set('view engine', 'jade')

        app.use('/st', express.static('./public'))
        app.use('/st/bower', express.static('./bower_components'))

    init_routers: ->
        app = @app

        app.get '/tab', (req, res) ->
            res.render 'ui/tab'

        app.get '/datasource/tab', (req, res) ->
            res.jsonp({
                cur: '.rock-panel'
                items: [
                    {
                        target: '.rec-panel'
                        name: '推荐'
                    },
                    {
                        target: '.pop-panel'
                        name: '流行'
                    },
                    {
                        target: '.rock-panel'
                        name: '摇滚'
                    },
                    {
                        target: '.hiphop-panel'
                        name: 'HipHop/说唱'
                    }
                ]
            })

    start_server: ->
        {app, port} = @
        app.listen port
        console.log(">> App start at port: #{port}")

new App(process.argv[2])
