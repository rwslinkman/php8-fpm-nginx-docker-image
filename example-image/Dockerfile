FROM rwslinkman/php8-fpm-nginx:1.0.1

# Override nginx host config
ADD example-config/nginx.conf /etc/nginx/conf.d/default.conf
COPY example-config/logs /var/www/myExampleApp/logs

# Add sources
COPY example-index.php /var/www/myExampleApp/public/index.php