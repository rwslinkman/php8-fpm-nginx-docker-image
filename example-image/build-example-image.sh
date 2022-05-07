#!/bin/sh
DOCKER_IMAGE=rwslinkman-example/example
docker build -t $DOCKER_IMAGE:latest .

echo "Finished building Docker image: $DOCKER_IMAGE:latest"