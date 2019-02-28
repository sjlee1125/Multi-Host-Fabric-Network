#!/bin/bash

ARCH=$(uname -s | grep Darwin)
if [ "$ARCH" == "Darwin" ]; then
 OPTS="-it"
else
 OPTS="-i"
fi

sed $OPTS "s/NAMEOFHOST/${HOSTNAME}/g" docker-compose-pc.yaml
