process.env.NODE_ENV ?= 'development'

gulp = require 'gulp'
gulp_if = require 'gulp-if'
gulp_coffee = require 'gulp-coffee'
gulp_concat = require 'gulp-concat'

{
    kit,
    kit: { Promise, _ }
} = require 'nobone'

run_server = (opts) ->
    { port, st, open } = _.defaults opts, {
        port: 8078
        st: 'public'
        open: false
    }

    kit.monitor_app {
        bin: 'coffee'
        args: ['./server.coffee', port, st, open]
        watch_list: [
            './server.coffee'
            './kit/**/*.coffee'
            './public/css/core/*.styl'
        ]
    }

##
# Options
##
option '-p', '--port [port]', 'Which port to listen to. Example: cake -p 8080 dev'

option '-q', '--quite',
    'Running lint script at quite mode results in only printing errors.
    Example: cake -q coffeelint'

option '-o', '--open', 'To open a webpage with default browser.'

option '-s', '--st [st]', 'Static directory.'

##
# Tasks
##
task 'setup', 'Setup project', ->
    setup = require './kit/setup'
    setup.start()

task 'build', 'Build project.', ->
    builder = require './kit/builder'
    builder.build()

task 'init', 'Create init files for client.', ->
    files = [
        'bower_components/lodash/dist/lodash.js'
        'bower_components/requirejs/require.js'
    ]

    for item in ['', 'webapp_']
        dest_file = "#{item}init.js"

        if item is 'webapp_'
            files.unshift 'bower_components/zeptojs/dist/zepto.js'
        else
            files.unshift 'bower_components/jquery/dist/jquery.js'

        gulp.src(files.concat "public/js/#{item}cfg.coffee")
            .pipe(gulp_if /[.]coffee$/, gulp_coffee())
            .pipe(gulp_concat "#{dest_file}")
            .pipe(gulp.dest 'public/js')

        kit.log ">> Create: ".cyan + "public/js/#{dest_file}"

    kit.log ">> Create init files done.".green

task 'dev', 'Run project on Development mode.', (opts) ->
    run_server(opts)

task 'coffeelint', 'Lint all coffee files.', (opts) ->
    expand = kit.require 'glob-expand'
    cwd = process.cwd()

    lint = (path) ->
        args = ['-f', "#{cwd}/coffeelint.json", "#{cwd}/#{path}"]
        if opts.quite
            args.unshift('-q')
        kit.spawn "#{cwd}/node_modules/.bin/coffeelint", args

    Promise.resolve(expand(
        '**/*.coffee',
        '!node_modules/**/*.coffee',
        '!bower_components/**/*.coffee'
    )).then (file_list) ->
        Promise.map file_list, lint
