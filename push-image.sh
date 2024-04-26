#!/bin/sh
INPUT=$1
TAG="${INPUT:-latest}"
PHP_VERSIONS=("8.0" "8.1" "8.2" "8.3")

DOCKER_HUB_REGISTRY=rwslinkman/php8-fpm-nginx

for PHP in ${PHP_VERSIONS[@]}; do
  echo "Pushing image $DOCKER_HUB_REGISTRY:$PHP-$TAG"
  docker push $DOCKER_HUB_REGISTRY:$PHP-$TAG
  echo "Finished pushing Docker image: $DOCKER_HUB_REGISTRY:$PHP-$TAG"
done

echo "Finished pushing all Docker images"