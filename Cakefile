process.env.NODE_ENV = 'development'

require 'coffee-script/register'
nobone = require 'nobone'

{ kit, service, renderer } = nobone()
{ Q, _ } = kit

serve_fake_datasource = ->
    kit.glob 'kit/datasource/*.coffee'
    .then (paths) ->
        Q.all paths.map (p) ->
            name = kit.path.basename p, '.coffee'
            url = "/datasource/#{name}"
            kit.log 'Fake Datasource: '.cyan + url
            service.get url, require('./' + p)

run_static_server = (opts) ->
    config = require './config'

    {port, st} = _.defaults opts, {
        port: 8078
        st: 'public'
    }

    renderer.file_handlers['.css'] = config.stylus_handler

    kit.glob 'views/ui/*.jade'
    .then (paths) ->
        Q.all paths.map (p) ->
            name = kit.path.basename p, '.jade'
            service.get '/' + name, (req, res) ->
                renderer.render(p, '.html').then (tpl_fn) ->
                    res.send tpl_fn()
    .then ->
        service.use '/st/bower', renderer.static('bower_components')
        service.use '/st', renderer.static(st)

        service.listen port, ->
            kit.log 'Start at port: '.cyan + port
            if ~~opts.open
                kit.open "http://127.0.0.1:#{port}/tab"
    .done()

option '-p', '--port [port]', 'Which port to listen to. Example: cake -p 8080 dev'
option '-o', '--open', 'Whether to open a webpage with the default browser?'
option '-s', '--st [st]', 'Static directory.'

task 'setup', 'Setup project', ->
    setup = require './kit/setup'
    setup.start()

task 'build', 'Build project.', (opts) ->
    builder = require './kit/builder'
    builder.build()

task 'dev', 'Run project on Development mode.', (opts) ->
    Q.fcall ->
        serve_fake_datasource()
    .then ->
        run_static_server(opts)
