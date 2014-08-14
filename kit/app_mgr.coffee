builder = require './builder'

main = ->
    argv = process.argv

    switch argv[2]
        when 'setup'
            setup = require './setup'
            setup.start()

        when 'build'
            builder.start()
            builder.watch()

main()
