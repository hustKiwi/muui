Q = require 'q'
_ = require 'lodash'
os = require '../lib/os'

class Setup
    start: ->
        Q.fcall ->
            os.spawn 'node_modules/.bin/bower', ['install']
        .then =>
            @build_zepto()
        .catch (e) ->
            if e.message is 'canceled'
                console.log '\n>> Canceled.'.red
                process.exit 0
        .done ->
            console.log '>> Setup done.'.yellow

    build_zepto: ->
        zepto_path = os.path.resolve os.path.join('bower_components', 'zeptojs')
        mods = 'zepto event ajax ie selector data callbacks deferred stack ios3'

        Q.fcall ->
            console.log ">> Install zepto dependencies.".cyan
            os.spawn 'npm', ['install'], {
                cwd: zepto_path
            }
        .then ->
            coffee_bin = os.path.join 'node_modules', '.bin', 'coffee'

            console.log '>> Build Zepto with: '.cyan + mods.green

            os.spawn coffee_bin, ['make', 'dist'], {
                cwd: zepto_path
                env: _.defaults(
                    { MODULES: mods }
                    process.env
                )
            }

module.exports = new Setup
