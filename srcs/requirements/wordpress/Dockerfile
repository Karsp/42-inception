FROM alpine:3.22

# Install PHP, extensions, and dependencies
RUN apk update && apk add --no-cache \
    php82 \
    php82-fpm \
    php82-mysqli \
    php82-json \
    php82-curl \
    php82-dom \
    php82-exif \
    php82-fileinfo \
    php82-mbstring \
    php82-openssl \
    php82-xml \
    php82-zip \
    php82-session \
    mariadb-client \
    wget \
    tar \
    curl \
    bash

# Prepare working directory
WORKDIR /var/www/html

# make sure PHP binaries are available in the default path.
RUN ln -sf /usr/bin/php82 /usr/bin/php && \
    ln -sf /usr/sbin/php-fpm82 /usr/sbin/php-fpm


# Copy WordPress setup script
COPY tools/setup_wordpress.sh /usr/local/bin/setup_wordpress.sh
RUN chmod +x /usr/local/bin/setup_wordpress.sh

# Configure PHP-FPM
RUN mkdir -p /run/php && \
    sed -i 's|^;daemonize = yes|daemonize = no|' /etc/php82/php-fpm.conf && \
    sed -i 's|^;clear_env = no|clear_env = no|' /etc/php82/php-fpm.d/www.conf && \
    sed -i 's|127\.0\.0\.1:9000|0.0.0.0:9000|' /etc/php82/php-fpm.d/www.conf

# Expose FPM port
EXPOSE 9000

# Run the setup script as the container entrypoint
ENTRYPOINT ["/usr/local/bin/setup_wordpress.sh"]
