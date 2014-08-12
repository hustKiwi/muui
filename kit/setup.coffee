os = require '../lib/os'
Q = require 'q'

class Setup
    start: ->
        Q.fcall ->
            os.spawn 'node_modules/.bin/bower', ['install']
        .catch (e) ->
            if e.message is 'canceled'
                console.log '\n>> Canceled.'.red
                process.exit 0
        .done ->
            console.log '>> Setup done.'.yellow

module.exports = new Setup
