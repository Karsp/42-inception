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
echo "Waiting for Portainer and Adminer..."
until ping -c1 portainer >/dev/null 2>&1 && ping -c1 adminer >/dev/null 2>&1; do
    sleep 2
done

# Start nginx in the foreground
exec nginx -g "daemon off;"