process.env.NODE_ENV = 'development'

require 'coffee-script/register'
nobone = require 'nobone'

{ kit, kit: { _ } } = nobone

run_server = (opts) ->
    compiler = require './kit/compiler'

    nodemon_bin = './node_modules/.bin/nodemon'

    {port, st, open} = _.defaults opts, {
        port: 8078
        st: 'public'
        open: false
    }

    kit.spawn nodemon_bin, [
        './server.coffee',
        port,
        st,
        open
    ]

option '-p', '--port [port]', 'Which port to listen to. Example: cake -p 8080 dev'
option '-o', '--open', 'Whether to open a webpage with the default browser?'
option '-s', '--st [st]', 'Static directory.'

task 'setup', 'Setup project', ->
    setup = require './kit/setup'
    setup.start()

task 'build', 'Build project.', ->
    builder = require './kit/builder'
    builder.build()

task 'dev', 'Run project on Development mode.', (opts) ->
    run_server(opts)
