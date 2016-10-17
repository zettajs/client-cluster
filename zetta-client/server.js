var uuid = require('uuid');
var zetta = require('zetta');
var MemoryRegistries = require('zetta-memory-registry')(zetta);
var Redirect = require('zetta-peer-redirect');
var PeerRegistry = MemoryRegistries.PeerRegistry;
var DeviceRegistry = MemoryRegistries.DeviceRegistry;
var Device = require('./device');

var CLIENTS = Number(process.env.CLIENTS) || 1;
var DEVICES = Number(process.env.DEVICES) || 5;
var SENSOR_INTERVAL = Number(process.env.SENSOR_INTERVAL);
var LAUNCH_JITTER_MIN = Number(process.env.LAUNCH_JITTER) || 5;

for (var i=0; i<CLIENTS; i++) {
  var jitter = Math.random() * (LAUNCH_JITTER_MIN * 60 * 1000);
  setTimeout(function() {
    var z = zetta({ registry: new DeviceRegistry(), peerRegistry: new PeerRegistry()})
        .silent()
        .name('loadtest-' + uuid.v4())
        .use(Redirect)
        .link(process.env.CLOUD_URL);

    for(var j=0; j<DEVICES; j++) {
      z.use(Device, { interval: SENSOR_INTERVAL });
    }
    
    z.listen(0);
  }, jitter);
}
