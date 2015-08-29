{ kit } = require 'nobone'

{ _, spawn, log, path, path: { join } } = kit

class Setup
    start: ->
        spawn join('nodeModules', '.bin', 'bower'), ['install']
        .then =>
            @buildZepto()
        .catch (err) ->
            if err.message is 'canceled'
                log '\n>> Canceled.'.red
                process.exit 0
        .done ->
            log '>> Setup done.'.yellow

    buildZepto: ->
        zeptoPath = join 'bowerComponents', 'zeptojs'
        mods = 'zepto event ajax ie selector data callbacks deferred stack ios3'

        log '>> Install zepto dependencies.'.cyan
        spawn 'npm', ['install'], {
            cwd: zeptoPath
        }
        .then ->
            coffeeBin = join 'nodeModules', '.bin', 'coffee'

            log '>> Build Zepto with: '.cyan + mods.green

            spawn coffeeBin, ['make', 'dist'], {
                cwd: zeptoPath
                env: _.defaults(
                    { MODULES: mods }
                    process.env
                )
            }

module.exports = new Setup
