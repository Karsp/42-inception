FROM alpine:3.22

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
    wget tar curl

# Download WordPress
WORKDIR /var/www/html
RUN wget https://wordpress.org/latest.tar.gz \
    && tar -xzf latest.tar.gz --strip-components=1 \
    && rm latest.tar.gz

# Configure PHP-FPM
RUN mkdir -p /run/php && \
    sed -i 's|^;daemonize = yes|daemonize = no|' /etc/php82/php-fpm.conf && \
    sed -i 's|^;clear_env = no|clear_env = no|' /etc/php82/php-fpm.d/www.conf && \
    sed -i 's|127\.0\.0\.1:9000|0.0.0.0:9000|' /etc/php82/php-fpm.d/www.conf

EXPOSE 9000
CMD ["php-fpm82", "-F"]
