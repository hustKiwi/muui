require 'coffee-script/register'
os = require './lib/os'
coffee_bin = './node_modules/.bin/coffee'

task 'watch', 'Watch source files and rebuild while it changes.', ->
    os.spawn coffee_bin, ['kit/app_mgr.coffee', 'watch']

task 'build', 'Build all source code.', ->
    os.spawn coffee_bin, ['kit/app_mgr.coffee', 'build']
