#!/bin/sh
set -e

DB_DIR="/var/lib/mysql"

# Initialize database if not exists
if [ ! -d "$DB_DIR/mysql" ]; then
    echo "[entrypoint] Initializing MariaDB data directory..."
    mariadb-install-db --user=mysql --datadir="$DB_DIR" --skip-test-db > /dev/null

    # Run initialization script only during first setup
    if [ -x /usr/local/bin/init_db.sh ]; then
        echo "[entrypoint] Running initialization script..."
        /usr/local/bin/init_db.sh
    fi
else
    echo "[entrypoint] Existing database detected, skipping init..."
fi

echo "[entrypoint] Starting MariaDB..."
echo "[entrypoint] Flushing blocked hosts..."
mariadb-admin -uroot -p"${MYSQL_ROOT_PASSWORD}" flush-hosts || true

exec "$@"