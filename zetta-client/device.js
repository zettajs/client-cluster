var util = require('util');
var Device = require('zetta').Device;

var Mock = module.exports = function(opts) {
  Device.call(this);
  this.opts = opts || {};
  this.value = 0;
  this.interval = this.opts.interval || 60000;
  this.jitter = this.opts.jitter || 1000; // 0-1000ms
};
util.inherits(Mock, Device);

Mock.prototype.init = function(config) {
  var name = this.opts.name || 'photocell';

  config
    .name(name)
    .type('mock-sensor')
    .monitor('value');

  var self = this;
  var counter = 0;
  setInterval(function() {
    self.value = ++counter;
  }, this.interval + this._jitter());
};

Mock.prototype._jitter = function() {
  return Math.floor(Math.random() * this.jitter);
};

