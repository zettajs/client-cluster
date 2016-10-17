#!/bin/bash

tenant="default"

servers=$(curl -s -H "X-Apigee-IoT-Tenant-ID:$tenant" $1 | jq -r .links[].href | grep "/servers" | gsort -R | head -n 10)

for server in $servers
do
    echo $server
    ab -H "X-Apigee-IoT-Tenant-ID:$tenant" -d -S -q -l -n 10 -c 2 $server | grep "Time per request:"
done

ab -H "X-Apigee-IoT-Tenant-ID:$tenant" -d -S -q -l -n 10 -c 2 $1


