# PHP8-FPM NGINX Docker Image
Docker image containing PHP8-fpm and NGINX as the webserver

**Available at Docker Hub:**   
https://hub.docker.com/r/rwslinkman/php8-fpm-nginx

```shell
docker pull rwslinkman/php8-fpm-nginx:1.0.0
```

## How to use
This image can be use in multiple ways:
- Use as a base for your custom Docker image
- Use as build image in Gitlab CI

### Custom Dockerfile
Create your Docker image based on this Dockerfile configuration.   
See the `example-image` directory for an example.    
```Dockerfile
FROM rwslinkman/php8-fpm-nginx:1.0.0

# Override nginx host config
ADD example-config/nginx.conf /etc/nginx/conf.d/default.conf
COPY example-config/logs /var/www/myExampleApp/logs
```

### Usage in Gitlab CI
```yaml
php-website-build:
  image: rwslinkman/php8-fpm-nginx:1.0.0
  stage: build
  script:
    - cd whereverMyWebsiteIs
    - composer install
```