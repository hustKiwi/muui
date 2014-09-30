process.env.NODE_ENV ?= 'development'

expand = require 'glob-expand'
{ kit: { Q, _, spawn } } = require 'nobone'

run_server = (opts) ->
    { port, st, open } = _.defaults opts, {
        port: 8078
        st: 'public'
        open: false
    }

    spawn './node_modules/.bin/coffee', [
        './server.coffee',
        port,
        st,
        open
    ]

option '-p', '--port [port]', 'Which port to listen to. Example: cake -p 8080 dev'
option '-q', '--quite',
    'Run lint script in the quite mode which only print errors.
    Example: cake -q coffeelint'
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

task 'coffeelint', 'Lint all coffee files.', (opts) ->
    cwd = process.cwd()
    lint = (path) ->
        args = ['-f', "#{cwd}/coffeelint.json", "#{cwd}/#{path}"]
        if opts.quite
            args.unshift('-q')
        spawn "#{cwd}/node_modules/.bin/coffeelint", args

    Q.fcall ->
        expand '**/*.coffee', '!node_modules/**/*.coffee', '!bower_components/**/*.coffee'
    .then (file_list) ->
        Q.all _.flatten(file_list).map lint
