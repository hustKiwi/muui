define(['muui/lib/eventEmitter/eventEmitter'], function(_EventEmitter) {
  var EventEmitter;
  return EventEmitter = (function() {
    function EventEmitter() {
      this._ee = new _EventEmitter();
    }

    EventEmitter.prototype.on = function() {
      this._ee.on.apply(this._ee, arguments);
      return this;
    };

    EventEmitter.prototype.off = function() {
      this._ee.off.apply(this._ee, arguments);
      return this;
    };

    EventEmitter.prototype.once = function() {
      this._ee.one.apply(this._ee, arguments);
      return this;
    };

    EventEmitter.prototype.trigger = function() {
      this._ee.emit.apply(this._ee, arguments);
      return this;
    };

    EventEmitter.prototype.addListeners = function() {
      return this._ee.addListeners.apply(this._ee, arguments);
    };

    return EventEmitter;

  })();
});
