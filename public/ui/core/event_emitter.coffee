define [
    'muui/lib/eventEmitter/eventEmitter'
], (_EventEmitter) ->
    class EventEmitter
        constructor: ->
            @_ee = new _EventEmitter()

        on: (args...) ->
            if _.isFunction args[1]
                args[1] = [args[1]]
            @_ee.addListeners.apply(@_ee, args)
            @

        off: ->
            @_ee.off.apply(@_ee, arguments)
            @

        once: ->
            @_ee.one.apply(@_ee, arguments)
            @

        trigger: ->
            @_ee.emit.apply(@_ee, arguments)
            @
