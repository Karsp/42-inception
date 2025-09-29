FROM alpine:3.22

RUN apk update && \
	apk add --no-cache nginx openssl

# Optional: create cert directory
#RUN mkdir -p /etc/nginx/certs

#COPY certs/server.crt /etc/nginx/certs/server.crt
#COPY certs/server.key /etc/nginx/certs/server.key

# Copiar el script y el archivo de configuración
COPY tools/generate_certs.sh /tmp/generate_certs.sh
COPY html/index.html /var/www/html/index.html
COPY conf/default.conf /etc/nginx/sites-available/default

# Dar permisos de ejecución al script y ejecutarlo
# RUN chmod +x /tmp/generate_certs.sh && /tmp/generate_certs.sh

# RUN chmod -R 755 /var/www/html
# RUN chown -R www-data:www-data /var/www/html


EXPOSE ${NGINX_PORT}

CMD ["nginx", "-g", "daemon off;"]