#!/bin/sh
set -e

DB_DIR="/var/lib/mysql"

if [ -f /run/secrets/db_root_password ]; then
    MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
fi

# Initialize database if not exists
if [ ! -d "$DB_DIR/mysql" ]; then
    echo "[entrypoint] Initializing MariaDB data directory..."
    mariadb-install-db --user=mysql --datadir="$DB_DIR" --skip-test-db > /dev/null

    if [ -x /usr/local/bin/init_db.sh ]; then
        echo "[entrypoint] Running initialization script..."
        /usr/local/bin/init_db.sh
    fi
else
    echo "[entrypoint] Existing database detected, skipping init..."
fi

echo "[entrypoint] Starting MariaDB..."
mysqld_safe --datadir="$DB_DIR" --user=mysql &
pid="$!"

echo "[entrypoint] Waiting for MariaDB server to start..."
until mysqladmin ping -h "127.0.0.1" --silent; do
    sleep 1
done

if [ -n "$MYSQL_ROOT_PASSWORD" ]; then
    echo "[entrypoint] Flushing blocked hosts..."
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH HOSTS;" || true
else
    echo "[entrypoint] Root Password secret not found."
fi

echo "[entrypoint] MariaDB ready and running (PID $pid)"
wait "$pid"
