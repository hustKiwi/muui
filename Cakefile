process.env.NODE_ENV = 'development'

require 'coffee-script/register'
{ kit } = require 'nobone'
coffee_bin = './node_modules/.bin/coffee'

task 'build', 'Build all source code.', ->
    kit.spawn coffee_bin, ['kit/app_mgr.coffee', 'build']

task 'dev', 'Build all source code.', ->
    kit.spawn coffee_bin, ['kit/app_mgr.coffee', 'dev']

option '-p', '--port [port]', 'Which port to listen to. Example: cake -p 8080 server'
task 'server', 'Start test server.', (opts) ->
    kit.spawn coffee_bin, ['kit/app_mgr.coffee', 'server', opts.port or 8077]
