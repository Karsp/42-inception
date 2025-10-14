#!/bin/sh
set -e

WWW_DIR="/var/www/html"

echo "[wordpress] Starting WordPress setup..."



# Clean volume content
rm -rf "$WWW_DIR"/*
mkdir -p "$WWW_DIR"

# --- Install WP-CLI ---
if ! command -v wp >/dev/null 2>&1; then
  echo "[wordpress] Installing WP-CLI..."
  curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod +x wp-cli.phar
  mv wp-cli.phar /usr/local/bin/wp
fi

# # Ensure PHP has enough memory
# echo "[wordpress] Setting PHP memory limit..."
# echo "memory_limit = 512M" > /etc/php82/conf.d/99-memory-limit.ini

# --- Download WordPress ---
# Check if wp exist
echo "[wordpress] Downloading WordPress..."
wp core download --allow-root --path="$WWW_DIR"

cd "$WWW_DIR"

# --- Configure wp-config.php ---
echo "[wordpress] Configuring wp-config.php..."
cp wp-config-sample.php wp-config.php

DB_PASS=$(cat /run/secrets/db_admin_password)

sed -i "s/database_name_here/${MYSQL_DATABASE}/" wp-config.php
sed -i "s/username_here/${DB_ADMIN_USER}/" wp-config.php
sed -i "s/password_here/${DB_PASS}/" wp-config.php
sed -i "s/localhost/mariadb/" wp-config.php

# --- Wait for MariaDB ---
# wait until we can authenticate and run a simple query against the DB
echo "[wordpress] Waiting for MariaDB to be fully ready for authentication..."
while ! mariadb --host=mariadb -u"${DB_ADMIN_USER}" -p"$(cat /run/secrets/db_admin_password)" \
    -e "SELECT 1" "${MYSQL_DATABASE}" >/dev/null 2>&1; do
  echo "[wordpress] DB not ready yet, sleeping 3s..."
  sleep 3
done
# small extra wait to be safe
sleep 2


# --- Install WordPress ---
echo "[wordpress] Installing WordPress..."
wp core install \
  --url="https://${DOMAIN_NAME}/" \
  --title="${WORDPRESS_TITLE}" \
  --admin_user="${DB_ADMIN_USER}" \
  --admin_password="${DB_PASS}" \
  --admin_email="${DB_ADMIN_EMAIL}" \
  --skip-email \
  --allow-root

# --- Create secondary user ---
echo "[wordpress] Creating secondary user..."
USER_PASSWORD=$(cat /run/secrets/user_password)
wp user create "${MYSQL_USER}" "${MYSQL_USER_EMAIL}" \
  --role=editor \
  --user_pass="${USER_PASSWORD}" \
  --allow-root

# --- Install and activate Astra theme ---
wp theme install astra --activate --allow-root

echo "[wordpress] Setup complete. Starting PHP-FPM..."
exec php-fpm82 -F
