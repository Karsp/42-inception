# WORDPRESS Dockerfile
FROM alpine:3.22

RUN apk update && apk add --no-cache \
    php82 \
    php82-fpm \
    php82-mysqli \
    php82-mbstring \
    php82-json \
    php82-session \
    php82-curl \
    curl wget tar \
    && rm -rf /var/cache/apk/*

RUN mkdir -p /etc/php82/php-fpm.d
# Copy custom php-fpm pool config
COPY conf/www.conf /etc/php82/php-fpm.d/www.conf

RUN mkdir -p /etc/php82/php-fpm.d

# Create web root and set permissions
WORKDIR /var/www/html

# Download WordPress
RUN curl -o wordpress.tar.gz https://wordpress.org/latest.tar.gz \
    && tar -xzf wordpress.tar.gz --strip 1 \
    && rm wordpress.tar.gz

CMD ["php-fpm82", "-F"]



#COPY ./tools/WORDPRESS_setup /run.sh

# CMD ["/run.sh"]