{ kit } = require 'nobone'

{ _, spawn, log, path, path: { join } } = kit

class Setup
    start: ->
        spawn 'bower', ['install']
        .then =>
            @buildZepto()
        .catch (err) ->
            if err.message is 'canceled'
                log '\n>> Canceled.'.red
                process.exit 0
        .then ->
            log '>> Setup done.'.yellow

    buildZepto: ->
        log '>> Install zepto dependencies.'.cyan

        zeptoPath = join 'bower_components', 'zeptojs'
        mods = 'zepto event ajax ie selector data callbacks deferred stack ios3'

        spawn 'yarn', [], {
          cwd: zeptoPath
        }
        .catch ->
          spawn 'npm', ['install'], {
              cwd: zeptoPath
          }
        .then ->
            log '>> Build Zepto with: '.cyan + mods.green

            spawn 'coffee', ['make', 'dist'], {
                cwd: zeptoPath
                env: _.defaults(
                    { MODULES: mods }
                    process.env
                )
            }

module.exports = new Setup
