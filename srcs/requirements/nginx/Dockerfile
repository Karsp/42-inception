FROM alpine:3.22

# Install nginx and openssl
RUN apk update && apk add --no-cache nginx openssl bash

# Create directories
RUN mkdir -p /etc/nginx/ssl /var/www/html /run/nginx && \
    chown -R nginx:nginx /var/www/html

# Copy entrypoint
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Copy NGINX configuration
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Expose HTTPS port
EXPOSE 443

# Start container using entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
