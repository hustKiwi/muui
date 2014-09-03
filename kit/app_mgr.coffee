# os = require '../lib/os'
{ kit } = require 'nobone'

app_path = kit.path.resolve kit.path.join(process.cwd(), 'app.coffee')
nodemon_bin = kit.path.resolve kit.path.join('node_modules','.bin', 'nodemon')

main = ->
    argv = process.argv

    switch argv[2]
        when 'setup'
            setup = require './setup'
            setup.start()

        when 'build'
            builder = require './builder'
            builder.build()

        when 'dev'
            builder = require './builder'
            builder.dev()

        when 'server'
            kit.spawn nodemon_bin, [app_path, argv[3]]

main()
