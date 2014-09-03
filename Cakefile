process.env.NODE_ENV = 'development'

require 'coffee-script/register'
nobone = require 'nobone'
{ kit, service, renderer } = nobone()
{ Q } = kit

task 'setup', 'Setup project', ->
	setup = require './kit/setup'
	setup.start()

task 'build', 'Build all source code.', ->
	builder = require './kit/builder'
	builder.build()

option '-p', '--port [port]', 'Which port to listen to. Example: cake -p 8080 server'
task 'dev', 'Build all source code.', (opts) ->
	serve_fake_datasource()

	run_static_server opts

serve_fake_datasource = ->
	kit.glob 'kit/datasource/*.coffee'
	.then (paths) ->
		Q.all paths.map (p) ->
			name = kit.path.basename p, '.coffee'
			url = "/datasource/#{name}"
			kit.log 'Fake Datasource: '.cyan + url
			service.get url, require('./' + p)
	.done()

run_static_server = (opts) ->
	port = opts.port or 8077

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
		service.use '/st', renderer.static('public')

		service.listen port, ->
			kit.log 'Start at port: '.cyan + port
			kit.open 'http://127.0.0.1:' + port
	.done()

