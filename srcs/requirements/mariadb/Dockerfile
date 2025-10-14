# Imagen base mínima
FROM alpine:3.22

# Install MariaDB, client, and OpenRC (used to create service dirs, not to start)
# su-exec is a tiny tool to run commands as another user without leaving open processes (better than sudo inside containers).
RUN apk update && apk add --no-cache mariadb mariadb-client openrc bash su-exec

# Prepare directories and permissions
RUN mkdir -p /run/mysqld /var/lib/mysql && \
    chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Copy optional custom configuration (bind-address, charset, etc.)
COPY conf/my.cnf /etc/my.cnf
RUN mkdir -p /etc/my.cnf.d \
    && echo -e "[mysqld]\nskip-name-resolve\nskip-host-cache\nmax_connect_errors=1000" > /etc/my.cnf.d/docker.cnf

# Initialization script(s) will be executed at first container init
# Copy the initialization script
COPY tools/init_db.sh /usr/local/bin/init_db.sh
RUN chmod +x /usr/local/bin/init_db.sh

# Copy and set entrypoint script (this replaces the official image logic)
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Disable name resolution in MariaDB by adding these lines to your config (/etc/my.cnf.d/docker.cnf):
RUN echo -e "[mysqld]\nskip-name-resolve\nskip-host-cache\nmax_connect_errors=1000" > /etc/my.cnf.d/docker.cnf



EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["mysqld", "--user=mysql", "--console"]
