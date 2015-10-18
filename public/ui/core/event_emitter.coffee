define [
    'muui/lib/eventEmitter/eventEmitter'
], (_EventEmitter) ->
    class EventEmitter
        constructor: ->
            @_ee = new _EventEmitter()

        on: ->
            @_ee.addListeners.apply(@_ee, arguments)
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
