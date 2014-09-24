nobone = require 'nobone'

{ kit, service, renderer } = nobone()
{ Q } = kit

serve_fake_datasource = ->
    kit.glob './kit/datasource/*.coffee'
    .then (paths) ->
        Q.all paths.map (p) ->
            name = kit.path.basename p, '.coffee'
            url = "/datasource/#{name}"
            kit.log 'Fake Datasource: '.cyan + url
            service.get url, require('./' + p)

serve_files = (opts) ->
    [port, st, open] = opts

    compiler = require './kit/compiler'
    html_compiler = renderer.file_handlers['.html'].compiler

    renderer.file_handlers['.html'] =
        ext_src: ['.html', '.jade']
        compiler: (str, path, data) ->
            if @ext is '.html'
                return str

            html_compiler.apply(@, [str, path, data])
    renderer.file_handlers['.css'] = compiler.stylus_handler
    renderer.file_handlers['.js'] = compiler.coffee_handler

    kit.glob 'views/ui/*.jade'
    .then (paths) ->
        Q.all paths.map (p) ->
            name = kit.path.basename p, '.jade'
            service.get '/' + name, (req, res) ->
                renderer.render(p, '.html').then (tpl_fn) ->
                    res.send tpl_fn()
    .then ->
        service.use '/st/bower', renderer.static('./bower_components')
        service.use '/st', renderer.static(st)

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
