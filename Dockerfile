FROM debian:buster

# Let the container know that there is no tty
ARG PHP_VERSION
ENV DEBIAN_FRONTEND noninteractive
ENV NGINX_VERSION 1.19.6-1~buster
ENV php_conf /etc/php/$PHP_VERSION/fpm/php.ini
ENV fpm_conf /etc/php/$PHP_VERSION/fpm/pool.d/www.conf
ENV COMPOSER_VERSION 2.0.8

# Install Basic Requirements
RUN buildDeps='curl gcc make autoconf libc-dev zlib1g-dev pkg-config' \
    && set -x \
    && apt-get update \
    && apt-get install --no-install-recommends $buildDeps --no-install-suggests -q -y gnupg2 dirmngr wget apt-transport-https lsb-release ca-certificates \
    && \
    NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62; \
	  found=''; \
	  for server in \
		  ha.pool.sks-keyservers.net \
		  hkp://keyserver.ubuntu.com:80 \
		  hkp://p80.pool.sks-keyservers.net:80 \
		  pgp.mit.edu \
	  ; do \
		  echo "Fetching GPG key $NGINX_GPGKEY from $server"; \
		  apt-key adv --batch --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break; \
	  done; \
    test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1; \
    echo "deb http://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list \
    && wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
    && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -q -y \
            apt-utils \
            nano \
            zip \
            unzip \
            python-pip \
            python-setuptools \
            git \
            libmemcached-dev \
            libmemcached11 \
            libmagickwand-dev \
            nginx=${NGINX_VERSION} \
            php${PHP_VERSION}-fpm \
            php${PHP_VERSION}-cli \
            php${PHP_VERSION}-bcmath \
            php${PHP_VERSION}-dev \
            php${PHP_VERSION}-common \
            php${PHP_VERSION}-opcache \
            php${PHP_VERSION}-readline \
            php${PHP_VERSION}-mbstring \
            php${PHP_VERSION}-curl \
            php${PHP_VERSION}-gd \
            php${PHP_VERSION}-imagick \
            php${PHP_VERSION}-mysql \
            php${PHP_VERSION}-zip \
            php${PHP_VERSION}-pgsql \
            php${PHP_VERSION}-intl \
            php${PHP_VERSION}-xml \
            php-pear \
    && pecl -d php_suffix=${PHP_VERSION} install -o -f redis memcached \
    && mkdir -p /run/php \
    && pip install wheel \
    && pip install supervisor supervisor-stdout \
    && echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d \
    && rm -rf /etc/nginx/conf.d/default.conf \
    && sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" ${php_conf} \
    && sed -i -e "s/memory_limit\s*=\s*.*/memory_limit = 256M/g" ${php_conf} \
    && sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" ${php_conf} \
    && sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" ${php_conf} \
    && sed -i -e "s/variables_order = \"GPCS\"/variables_order = \"EGPCS\"/g" ${php_conf} \
    && sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/${PHP_VERSION}/fpm/php-fpm.conf \
    && sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" ${fpm_conf} \
    && sed -i -e "s/pm.max_children = 5/pm.max_children = 4/g" ${fpm_conf} \
    && sed -i -e "s/pm.start_servers = 2/pm.start_servers = 3/g" ${fpm_conf} \
    && sed -i -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = 2/g" ${fpm_conf} \
    && sed -i -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = 4/g" ${fpm_conf} \
    && sed -i -e "s/pm.max_requests = 500/pm.max_requests = 200/g" ${fpm_conf} \
    && sed -i -e "s/www-data/nginx/g" ${fpm_conf} \
    && sed -i -e "s/^;clear_env = no$/clear_env = no/" ${fpm_conf} \
    && echo "extension=redis.so" > /etc/php/${PHP_VERSION}/mods-available/redis.ini \
    && echo "extension=memcached.so" > /etc/php/${PHP_VERSION}/mods-available/memcached.ini \
    && echo "extension=imagick.so" > /etc/php/${PHP_VERSION}/mods-available/imagick.ini \
    && ln -sf /etc/php/${PHP_VERSION}/mods-available/redis.ini /etc/php/${PHP_VERSION}/fpm/conf.d/20-redis.ini \
    && ln -sf /etc/php/${PHP_VERSION}/mods-available/redis.ini /etc/php/${PHP_VERSION}/cli/conf.d/20-redis.ini \
    && ln -sf /etc/php/${PHP_VERSION}/mods-available/memcached.ini /etc/php/${PHP_VERSION}/fpm/conf.d/20-memcached.ini \
    && ln -sf /etc/php/${PHP_VERSION}/mods-available/memcached.ini /etc/php/${PHP_VERSION}/cli/conf.d/20-memcached.ini \
    && ln -sf /etc/php/${PHP_VERSION}/mods-available/imagick.ini /etc/php/${PHP_VERSION}/fpm/conf.d/20-imagick.ini \
    && ln -sf /etc/php/${PHP_VERSION}/mods-available/imagick.ini /etc/php/${PHP_VERSION}/cli/conf.d/20-imagick.ini \
    # Install Composer
    && curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
    && curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
    && php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" \
    && php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION} \
    && rm -rf /tmp/composer-setup.php \
    # Clean up
    && rm -rf /tmp/pear \
    && apt-get purge -y --auto-remove $buildDeps \
    && apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

# Supervisor config
ADD tools/supervisord.conf /etc/supervisord.conf

# Override nginx's default config
ADD tools/default.conf /etc/nginx/conf.d/default.conf

# Override default nginx welcome page
COPY html /usr/share/nginx/html

# Add Scripts
ADD tools/start.sh /start.sh

EXPOSE 80

CMD ["/start.sh"]