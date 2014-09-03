{ kit } = require 'nobone'

{ Q, _ } = kit

class Setup
    start: ->
        Q.fcall ->
            kit.spawn 'node_modules/.bin/bower', ['install']
        .then =>
            @build_zepto()
        .catch (e) ->
            if e.message is 'canceled'
                console.log '\n>> Canceled.'.red
                process.exit 0
        .done ->
            console.log '>> Setup done.'.yellow

    build_zepto: ->
        zepto_path = kit.path.resolve kit.path.join('bower_components', 'zeptojs')
        mods = 'zepto event ajax ie selector data callbacks deferred stack ios3'

        Q.fcall ->
            console.log ">> Install zepto dependencies.".cyan
            kit.spawn 'npm', ['install'], {
                cwd: zepto_path
            }
        .then ->
            coffee_bin = kit.path.join 'node_modules', '.bin', 'coffee'

            console.log '>> Build Zepto with: '.cyan + mods.green

            kit.spawn coffee_bin, ['make', 'dist'], {
                cwd: zepto_path
                env: _.defaults(
                    { MODULES: mods }
                    process.env
                )
            }

module.exports = new Setup
