require 'coffee-script/register'
os = require './lib/os'
coffee_bin = './node_modules/.bin/coffee'

task 'build', 'Build all source code.', ->
    os.spawn coffee_bin, ['kit/app_mgr.coffee', 'build']

task 'watch', 'Build all source code.', ->
    os.spawn coffee_bin, ['kit/app_mgr.coffee', 'watch']

option '-p', '--port [port]', 'Which port to listen to. Example: cake -p 8080 server'
task 'server', 'Start test server.', (opts) ->
    os.spawn coffee_bin, ['kit/app_mgr.coffee', 'server', opts.port or 8077]
