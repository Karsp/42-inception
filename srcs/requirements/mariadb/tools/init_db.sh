#!/bin/sh
set -e

# Check Docker secrets first
if [ -f /run/secrets/db_root_password ]; then
    MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
fi

if [ -f /run/secrets/user_password ]; then
    MYSQL_USER_PASSWORD=$(cat /run/secrets/user_password)
fi

if [ -f /run/secrets/db_admin_password ]; then
    DB_ADMIN_PASSWORD=$(cat /run/secrets/db_admin_password)
fi


# Load environment variables (from docker-compose or secrets)
: "${MYSQL_ROOT_PASSWORD:?Need to set MYSQL_ROOT_PASSWORD}"
: "${MYSQL_DATABASE:?Need to set MYSQL_DATABASE}"
: "${MYSQL_USER:?Need to set MYSQL_USER}"
: "${MYSQL_USER_PASSWORD:?Need to set MYSQL_USER_PASSWORD}"
: "${DB_ADMIN_USER:?Need to set DB_ADMIN_USER}"
: "${DB_ADMIN_PASSWORD:?Need to set DB_ADMIN_PASSWORD}"


echo "[init_db] Setting up initial database and users..."

# Start a temporary MariaDB server
mariadbd-safe --skip-networking --socket=/run/mysqld/mysqld.sock &
sleep 5

# Apply SQL commands using new mariadb CLI
mariadb -uroot <<-EOSQL
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    DELETE FROM mysql.user WHERE User='';
    DROP DATABASE IF EXISTS test;
    CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_USER_PASSWORD}';
    CREATE USER IF NOT EXISTS '${DB_ADMIN_USER}'@'%' IDENTIFIED BY '${DB_ADMIN_PASSWORD}';

    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${DB_ADMIN_USER}'@'%';
    GRANT SELECT, INSERT, UPDATE, DELETE ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
    FLUSH PRIVILEGES;
EOSQL

# Shutdown temporary server using the new mariadb-admin CLI
mariadb-admin -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown

echo "[init_db] Initialization complete."
