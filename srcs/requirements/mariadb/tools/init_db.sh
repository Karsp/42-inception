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

# Ensure proper permissions before start
chown -R mysql:mysql /var/lib/mysql /run/mysqld

echo "[init_db] Starting temporary MariaDB server (no networking)..."
su-exec mysql mariadbd --skip-networking --socket=/run/mysqld/mysqld.sock &
pid=$!

# Wait until socket is ready
for i in $(seq 1 20); do
    if [ -S /run/mysqld/mysqld.sock ]; then
        echo "[init_db] MariaDB socket available."
        break
    fi
    echo "[init_db] Waiting for MariaDB socket... ($i)"
    sleep 1
done

# Apply SQL initialization
echo "[init_db] Applying initial SQL setup..."
mariadb --socket=/run/mysqld/mysqld.sock -u root <<-EOSQL
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

echo "[init_db] Initialization SQL complete. Shutting down temporary server..."
mariadb-admin --socket=/run/mysqld/mysqld.sock -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown

wait "$pid" || true
echo "[init_db] Initialization complete."
