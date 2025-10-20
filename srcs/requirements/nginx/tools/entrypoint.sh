#!/bin/sh
set -e

# Copy secrets into proper location
cp /run/secrets/tls_cert /etc/nginx/ssl/cert.pem
cp /run/secrets/tls_key /etc/nginx/ssl/key.pem

# Redirect logs to stdout/stderr
ln -sf /dev/stdout /var/log/nginx/access.log
ln -sf /dev/stderr /var/log/nginx/error.log

# Substitute env vars in nginx.conf
envsubst '$DOMAIN_NAME' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# Wait for upstream services to be reachable
echo "Waiting for WordPress, Portainer and Adminer..."
until nc -z wordpress 9000 && nc -z portainer 9443 && nc -z adminer 8080; do
    sleep 2
done
echo "All backends up, starting nginx..."

# Start nginx in the foreground
exec nginx -g "daemon off;"