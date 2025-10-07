#!/bin/sh
set -e

# Copy secrets into proper location
cp /run/secrets/tls_cert /etc/nginx/ssl/cert.pem
cp /run/secrets/tls_key /etc/nginx/ssl/key.pem

# Start nginx in the foreground
exec nginx -g "daemon off;"
