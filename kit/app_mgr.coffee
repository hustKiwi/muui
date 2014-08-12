builder = require './builder'

main = ->
    argv = process.argv

    switch argv[2]
        when 'setup'
            setup = require './setup'
            setup.start()

        when 'watch'
            builder.watch()

        when 'build'
            builder.start()

main()
