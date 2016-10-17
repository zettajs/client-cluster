var fs = require('fs');
var path = require('path');
var Handlebars = require('handlebars');

function content(f) {
  return fs.readFileSync(f).toString().split('\n').map(l => { return '      ' + l; }).join('\n');
}

var template = Handlebars.compile(fs.readFileSync('user-data.hb').toString());


var services = fs.readdirSync(path.join(__dirname,'./services')).map(function(f) {
  return {
    name: f,
    content: content(path.join(__dirname,'./services', f))
  };
});

var config = {
  serviceFiles: services,
  services: ['telegraf'],
  files: [
    {
      path: '/home/core/tele.conf',
      content: content('./tele.conf')
    }
  ],
  config: [
    { name: 'INFLUXDB_HOST', value: 'http://<metrics db>:8086' },
    { name: 'INFLUXDB_USERNAME', value: '<user>' },
    { name: 'INFLUXDB_PASSWORD', value: '<password>' },
    
    { name: 'CLOUD_URL', value: '<>' }, 
    
    { name: 'CLIENTS', value: '50' }, // number of zetta instances per docker container
    { name: 'DEVICES', value: '5' }, // number of devices per hub
    { name: 'SENSOR_INTERVAL', value: '60000' } // interval hub sends data + 0-1000ms jitter
  ]
};


var DOCKER_CONTAINERS = 100; // Number of docker containers per instance

for (var i=0; i<DOCKER_CONTAINERS; i++) {
  config.services.push('zetta-client@' + (i+1));
}

// Write to output file
fs.writeFileSync('.user-data', template(config));


