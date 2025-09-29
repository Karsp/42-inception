# Imagen base mínima
FROM alpine:3.22

RUN apk update && apk add --no-cache mariadb mariadb-client openrc

# Create necessary directories
RUN mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Copy your custom config (optional, e.g. bind-address, port, etc.)
# COPY conf/my.cnf /etc/my.cnf

# Declaramos el puerto que usará nginx 
EXPOSE 3306 

# Ensure database is initialized at build time
COPY ./conf/default.conf /etc/mysql/mariadb.conf.d/default.conf

COPY ./tools/MYSQL_setup /run.sh

RUN chmod +x /run.sh

ENTRYPOINT [ "/run.sh" ]

# Start MariaDB when the container runs
CMD ["mysqld", "--user=mysql", "--datadir=/var/lib/mysql"]
