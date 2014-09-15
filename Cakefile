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
	port = opts.port

	renderer.file_handlers['.css'].ext_src = ['.styl']

	kit.glob 'views/ui/*.jade'
	.then (paths) ->
		Q.all paths.map (p) ->
			name = kit.path.basename p, '.jade'
			service.get '/' + name, (req, res) ->
				renderer.render(p, '.html').then (tpl_fn) ->
					res.send tpl_fn()
	.then ->
		service.use '/st/bower', renderer.static('bower_components')
		service.use '/st', renderer.static(opts.st_path)

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

task 'build', 'Build project.', ->
	builder = require './kit/builder'
	builder.build().then ->
        clean()
    .then ->
        serve_fake_datasource()
    .then ->
        run_static_server _.defaults({
            port: 8078
            st_path: 'dist'
        }, opts)

task 'dev', 'Run project on Development mode.', (opts) ->
    Q.fcall ->
        serve_fake_datasource()
    .then ->
        run_static_server _.defaults({
            port: 8077
            st_path: 'public'
        }, opts)
