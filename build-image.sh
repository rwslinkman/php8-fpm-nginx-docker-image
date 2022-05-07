#!/bin/sh
INPUT=$1
TAG="${INPUT:-latest}"

DOCKER_HUB_REGISTRY=rwslinkman/php8-fpm-nginx

docker build -t $DOCKER_HUB_REGISTRY:$TAG .

echo "Finished building Docker image: $DOCKER_HUB_REGISTRY:$TAG"