#cloud-config

coreos:
  etcd2:
    proxy: on
    listen-client-urls: http://0.0.0.0:4001
  update:
    reboot-strategy: off
  units:
    - name: update-engine.service
      command: stop
      enable: false
    - name: etcd2.service
      command: stop
      drop-ins:
        - name: "timeout.conf"
          content: |
            [Service]
            TimeoutStartSec=0
    - name: fleet.service
      command: stop
    - name: docker.service
      drop-ins:
        - name: 10-logs-driver.conf
          content: |
            [Service]
            Environment="DOCKER_OPTS=--log-opt max-size=1m --log-opt max-file=10"
    - name: docker-tcp.socket
      command: start
      enable: true
      content: |
        [Unit]
        Description=Docker Socket for the API

        [Socket]
        ListenStream=2375
        Service=docker.service
        BindIPv6Only=both

        [Install]
        WantedBy=sockets.target
    {{#services}}
    - name: {{this}}.service
      command: start
    {{/services}}
write_files:
  {{#serviceFiles}}
  - path: /etc/systemd/system/{{name}}
    permissions: 644
    owner: root
    content: |
{{{content}}}
  {{/serviceFiles}}
  {{#files}}
  - path: {{path}}
    permissions: 644
    owner: root
    content: |
{{{content}}}
  {{/files}}
  - path: /etc/profile.d/vars
    permissions: 644
    owner: root
    content: |
      {{#config}}
      {{name}}={{{value}}}
      {{/config}}
