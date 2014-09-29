nobone = require 'nobone'

{ kit, service, renderer } = nobone()
{ Q, _ } = kit

serve_fake_datasource = ->
    kit.glob './kit/datasource/*.coffee'
    .then (paths) ->
        Q.all paths.map (p) ->
            name = kit.path.basename p, '.coffee'
            url = "/datasource/#{name}"
            kit.log 'Fake datasource: '.cyan + url
            service.get url, require('./' + p)

serve_files = (opts) ->
    [port, st, open] = opts

    compiler = require './kit/compiler'

    renderer.file_handlers['.html'] = compiler.html_handler
    renderer.file_handlers['.css'] = compiler.css_handler
    renderer.file_handlers['.js'] = compiler.js_handler

    render_jade = (route, path, data = {}) ->
        service.get route, (req, res) ->
            renderer.render(path, '.html').then (tpl_fn) ->
                try
                    res.send tpl_fn _.extend(data, req.query)
                catch err
                    kit.err err.stack.red

    Q.fcall ->
        render_jade '/', 'views/index.jade'
    .then ->
        kit.glob 'views/ui/**/*.jade'
    .then (paths) ->
        Q.all paths.map (p) ->
            if p.indexOf('views/ui/include') is 0
                name = p.substring(9, p.length - 5)
            else
                name = kit.path.basename p, '.jade'

            kit.log "Create route: ".cyan + name

            render_jade "/#{name}", p, {
                ui_name: name
            }
    .done ->
        service.use '/st/bower', renderer.static('./bower_components')
        service.use '/st', renderer.static(st)

        # https://github.com/strongloop/express/blob/master/examples/error-pages/index.js
        service.use (req, res, next) ->
            res.status(404)

            if req.accepts('html')
                res.redirect '/'

        service.listen port, ->
            kit.log 'Start at port: '.cyan + port
            if open is 'true'
                kit.open "http://127.0.0.1:#{port}/tab"

class Server
    constructor: (port, st) ->
        Q.fcall ->
            serve_fake_datasource()
        .then ->
            serve_files(port, st)
        .done()

new Server(process.argv[2..4])
