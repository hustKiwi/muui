os = require '../lib/os'
builder = require './builder'

app_path = os.path.resolve os.path.join(process.cwd(), 'app.coffee')
nodemon_bin = os.path.resolve os.path.join('node_modules','.bin', 'nodemon')

main = ->
    argv = process.argv

    switch argv[2]
        when 'setup'
            setup = require './setup'
            setup.start()

        when 'build'
            builder.start()
            builder.watch()

        when 'server'
            os.spawn nodemon_bin, [app_path, argv[3]]

main()
