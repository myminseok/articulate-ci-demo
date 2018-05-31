#!/bin/bash
export HOST_IP=`ip -4 addr show scope global dev docker0 | grep inet | awk '{print \$2}' | cut -d / -f 1`
echo $HOST_IP
docker-compose up  -d
