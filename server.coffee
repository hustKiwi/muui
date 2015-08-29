nobone = require 'nobone'

{ kit, service, renderer } = nobone()
{ Promise, _ } = kit

kit.require 'colors'

serveFakeDatasource = ->
    kit.glob './kit/datasource/*.coffee'
    .then (paths) ->
        Promise.all paths.map (p) ->
            name = kit.path.basename p, '.coffee'
            url = "/datasource/#{name}"
            kit.log 'Fake datasource: '.cyan + url
            service.get url, require('./' + p)

serveFiles = (port, st, open) ->
    compiler = require './kit/compiler'

    renderer.fileHandlers['.html'] = compiler.htmlHandler
    renderer.fileHandlers['.css'] = compiler.cssHandler
    renderer.fileHandlers['.js'] = compiler.jsHandler

    renderJade = (route, path, data = {}) ->
        service.get route, (req, res) ->
            renderer.render(path, '.html').then (tplFn) ->
                try
                    res.send tplFn _.extend(data, req.query)
                catch err
                    kit.err err.stack.red

    Promise.resolve().then ->
        renderJade '/', 'views/index.jade'
    .then ->
        kit.glob 'views/ui/**/*.jade'
    .then (paths) ->
        Promise.all paths.map (p) ->
            if p.indexOf('views/ui/include') is 0
                name = p.substring(9, p.length - 5)
            else
                name = kit.path.basename p, '.jade'

            kit.log 'Create route: '.cyan + name

            renderJade "/#{name}", p, {
                uiName: name
            }
    .then ->
        service.use '/st/bower', renderer.static('./bower_components')
        service.use '/st', renderer.static(st)

        # https://github.com/strongloop/express/blob/master/examples/error-pages/index.js
        service.use (req, res, next) ->
            res.status(404)

            if req.accepts('html')
                res.redirect '/'

        service.listen port, ->
            kit.log 'Start at port: '.cyan + port
            if open
                kit.open "http://127.0.0.1:#{port}/tab"

class Server
    constructor: ([ port, st, open ]) ->
        open = open is 'true'
        serveFakeDatasource().then ->
            serveFiles(port, st, open)

new Server(process.argv[2..4])
