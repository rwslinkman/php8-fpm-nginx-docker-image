# PHP8-FPM NGINX Docker Image
Docker image containing PHP8-fpm and NGINX as the webserver based on `debian:buster`

**Available at Docker Hub:**   
https://hub.docker.com/r/rwslinkman/php8-fpm-nginx

```shell
docker pull rwslinkman/php8-fpm-nginx:8.3-1.2.0
```

Multiple PHP versions supported:
- 8.0
- 8.1
- 8.2
- 8.3

## How to use
This image can be use in multiple ways:
- Use as a base for your custom Docker image
- Use as build image in Gitlab CI

### Custom Dockerfile
Create your Docker image based on this Dockerfile configuration.   
See the `example-image` directory for an example.    
```Dockerfile
FROM rwslinkman/php8-fpm-nginx:8.3-1.2.0

# Override nginx host config
ADD example-config/nginx.conf /etc/nginx/conf.d/default.conf
COPY example-config/logs /var/www/myExampleApp/logs

# Add sources
COPY example-index.php /var/www/myExampleApp/public/index.php
```

### Usage in Gitlab CI
```yaml
php-website-build:
  image: rwslinkman/php8-fpm-nginx:8.3-1.2.0
  stage: build
  script:
    - cd whereverMyWebsiteIs
    - composer install
```

## List of included packages
- PHP 8.x, dependend on chosen version
- NGINX
- Composer
- PHP modules
    - fpm
    - cli
    - bcmath
    - dev
    - common
    - opcache
    - readline
    - mbstring
    - curl
    - gd
    - imagick
    - mysql
    - zip
    - pgsql
    - intl
    - xml
- Redis
- Memcached
- Imagick