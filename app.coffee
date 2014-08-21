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
        @routes = require './routes/index'
        @routes.init(@app)

    start_server: ->
        {app, port} = @
        app.listen port
        console.log(">> App start at port: #{port}")

new App(process.argv[2])
