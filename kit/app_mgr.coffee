os = require '../lib/os'

app_path = os.path.resolve os.path.join(process.cwd(), 'app.coffee')
nodemon_bin = os.path.resolve os.path.join('node_modules','.bin', 'nodemon')

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
            builder.start()

        when 'watch'
            builder = require './builder'
            builder.watch()

        when 'server'
            os.spawn nodemon_bin, [app_path, argv[3]]

main()
