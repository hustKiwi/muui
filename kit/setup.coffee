{ kit } = require 'nobone'

{ Q, _, spawn, log } = kit

class Setup
    start: ->
        Q.fcall ->
            spawn 'node_modules/.bin/bower', ['install']
        .then =>
            @build_zepto()
        .catch (err) ->
            if err.message is 'canceled'
                log '\n>> Canceled.'.red
                process.exit 0
        .done ->
            log '>> Setup done.'.yellow

    build_zepto: ->
        zepto_path = kit.path.resolve kit.path.join('bower_components', 'zeptojs')
        mods = 'zepto event ajax ie selector data callbacks deferred stack ios3'

        Q.fcall ->
            log ">> Install zepto dependencies.".cyan
            spawn 'npm', ['install'], {
                cwd: zepto_path
            }
        .then ->
            coffee_bin = kit.path.join 'node_modules', '.bin', 'coffee'

            log '>> Build Zepto with: '.cyan + mods.green

            spawn coffee_bin, ['make', 'dist'], {
                cwd: zepto_path
                env: _.defaults(
                    { MODULES: mods }
                    process.env
                )
            }

module.exports = new Setup
