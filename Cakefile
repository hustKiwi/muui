process.env.NODE_ENV = 'development'

require 'coffee-script/register'
nobone = require 'nobone'

{ kit, service, renderer } = nobone()
{ Q, _ } = kit

clean = ->
    kit.glob 'public/**/*.+(css)'
    .then (paths) ->
        Q.all paths.map (p) ->
            kit.remove p
    .then ->
        kit.log 'Cleaned.'.green

serve_fake_datasource = ->
    kit.glob 'kit/datasource/*.coffee'
    .then (paths) ->
        Q.all paths.map (p) ->
            name = kit.path.basename p, '.coffee'
            url = "/datasource/#{name}"
            kit.log 'Fake Datasource: '.cyan + url
            service.get url, require('./' + p)

run_static_server = (opts) ->
    {port, st} = opts

    renderer.file_handlers['.css'] =
        ext_src: ['.styl']
        dependency_reg: /@(?:import|require)\s+([^\r\n]+)/
        compiler: (str, path) ->
            nib = kit.require 'nib'
            stylus = kit.require 'stylus'
            deferred = Q.defer()
            stylus(str)
                .set 'filename', path
                .set 'compress', process.env.NODE_ENV is 'production'
                .set 'paths', [__dirname + '/public/css']
                .use nib()
                .import 'nib'
                .import 'core/base'
                .render (err, css) ->
                    throw err if err
                    deferred.resolve(css)
            deferred.promise

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
            kit.open "http://127.0.0.1:#{port}/tab"
    .done()

option '-p', '--port [port]', 'Which port to listen to. Example: cake -p 8080 server'

task 'setup', 'Setup project', ->
    setup = require './kit/setup'
    setup.start()

task 'clean', 'Clean binary files', ->
    clean()

task 'build', 'Build project.', (opts) ->
    builder = require './kit/builder'
    builder.build().then ->
        clean()
    .then ->
        serve_fake_datasource()
    .then ->
        run_static_server _.defaults({
            st: 'dist'
            port: 8078
        }, opts)

task 'dev', 'Run project on Development mode.', (opts) ->
    Q.fcall ->
        serve_fake_datasource()
    .then ->
        run_static_server _.defaults({
            st: 'public'
            port: 8077
        }, opts)
