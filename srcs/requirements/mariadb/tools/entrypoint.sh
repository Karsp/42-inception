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

    # Run initialization script only during first setup
    if [ -x /usr/local/bin/init_db.sh ]; then
        echo "[entrypoint] Running initialization script..."
        /usr/local/bin/init_db.sh
    fi
else
    echo "[entrypoint] Existing database detected, skipping init..."
fi

echo "[entrypoint] Starting MariaDB..."
# if [ -f /run/secrets/db_root_password ]; then
#     MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
# 	# echo "[entrypoint] Flushing blocked hosts..."
# 	# mariadb-admin -uroot -p"${MYSQL_ROOT_PASSWORD}" flush-hosts || true
# 	echo "[entrypoint] Flushing blocked hosts..."
# 	for i in $(seq 1 10); do
# 		if mariadb-admin ping -uroot -p"${MYSQL_ROOT_PASSWORD}" --silent 2>/dev/null; then
# 			mariadb-admin -uroot -p"${MYSQL_ROOT_PASSWORD}" flush-hosts && break
# 		fi
# 		echo "[entrypoint] Waiting for MariaDB before flush-hosts... ($i)"
# 		sleep 2
# 	done
# else
#     echo "[entrypoint] Root Password secret not found."
# fi

exec su-exec mysql "$@" #drop privileges inside the entrypoint
