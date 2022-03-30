#!/usr/bin/env bash

OWNER=${OWNER:-axia}
IMAGE_NAME=${IMAGE_NAME:-axia-collator}
docker build --no-cache --build-arg IMAGE_NAME=$IMAGE_NAME -t $OWNER/$IMAGE_NAME -f ./docker/injected.Dockerfile .
docker images | grep $IMAGE_NAME
