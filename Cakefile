process.env.NODE_ENV ?= 'development'

{ kit, kit: { _ } } = require 'nobone'

run_server = (opts) ->
    {port, st, open} = _.defaults opts, {
        port: 8078
        st: 'public'
        open: false
    }

    kit.spawn './node_modules/.bin/coffee', [
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
