# Imagen base mínima
FROM alpine:3.22

# Install MariaDB, client, and OpenRC (used to create service dirs, not to start)
RUN apk update && apk add --no-cache mariadb mariadb-client openrc bash

# Prepare directories and permissions
RUN mkdir -p /run/mysqld /var/lib/mysql && \
    chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Copy optional custom configuration (bind-address, charset, etc.)
COPY conf/my.cnf /etc/my.cnf

# Initialization script(s) will be executed at first container init
# Copy the initialization script
COPY tools/init_db.sh /usr/local/bin/init_db.sh
RUN chmod +x /usr/local/bin/init_db.sh

# Copy and set entrypoint script (this replaces the official image logic)
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["mysqld", "--user=mysql", "--console"]
