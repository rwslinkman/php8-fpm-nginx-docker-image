#!/bin/sh
INPUT=$1
TAG="${INPUT:-latest}"

DOCKER_HUB_REGISTRY=rwslinkman/php8-fpm-nginx

docker push $DOCKER_HUB_REGISTRY:$TAG
echo "Finished pushing Docker image: $DOCKER_HUB_REGISTRY:$TAG"