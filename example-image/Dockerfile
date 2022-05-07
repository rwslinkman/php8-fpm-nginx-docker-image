FROM rwslinkman/php8-fpm-nginx:1.0.0

# Override nginx host config
ADD example-config/nginx.conf /etc/nginx/conf.d/default.conf
COPY example-config/logs /var/www/myExampleApp/logs

# Add sources (might not apply to you)
COPY public /var/www/myExampleApp/public
COPY src /var/www/myExampleApp/src
COPY templates /var/www/myExampleApp/templates
COPY vendor /var/www/myExampleApp/vendor
