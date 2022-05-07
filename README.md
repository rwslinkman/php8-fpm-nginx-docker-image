# PHP8-FPM NGINX Docker Image
Docker image containing PHP8-fpm and NGINX as the webserver

**Available at Docker Hub:**   
https://hub.docker.com/repository/docker/rwslinkman/php8-fpm-nginx

## How to use
This image can be use in multiple ways:
- Use as a base for your custom Docker image
- Use as build image in Gitlab CI
- Pull from Docker Hub

### Custom Dockerfile
Example coming soon

### Usage in Gitlab CI
```yaml
php-website-build:
  image: rwslinkman/php8-fpm-nginx:1.0.0
  stage: build
  script:
    - cd whereverMyWebsiteIs
    - composer install
```

### Usage in CLI
```shell
docker pull rwslinkman/php8-fpm-nginx:1.0.0
```

