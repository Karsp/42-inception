# Imagen base mínima
FROM alpine:3.22

RUN apk update && apk add --no-cache mariadb mariadb-client openrc

# Create necessary directories
RUN mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Copy your custom config (optional, e.g. bind-address, port, etc.)
# COPY conf/my.cnf /etc/my.cnf

# Ensure database is initialized at build time
COPY ./conf/my.cnf /etc/mysql/mariadb.conf.d/my.cnf

COPY ./tools/dbSetup /run.sh

RUN chmod +x /run.sh

ENTRYPOINT [ "/run.sh" ]

# Start MariaDB when the container runs
CMD ["mysqld", "--user=mysql", "--datadir=/var/lib/mysql"]
