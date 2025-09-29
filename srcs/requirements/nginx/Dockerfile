FROM alpine:3.22

RUN apk update && \
	apk add --no-cache nginx openssl

# Optional: create cert directory
#RUN mkdir -p /etc/nginx/certs

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048\
            -keyout /etc/ssl/private/nginx-selfsigned.key\
            -out /etc/ssl/certs/nginx-selfsigned.crt\
            -subj "/C=ES/L=MD/O=42/OU=student/CN=$DOMAIN_NAME"

COPY html/index.html /var/www/html/index.html
COPY ./conf/nginx.conf /etc/nginx/sites-available/

# Copiar el script y el archivo de configuración
# COPY tools/generate_certs.sh /tmp/generate_certs.sh
# COPY html/index.html /var/www/html/index.html
# COPY conf/nginx.conf /etc/nginx/sites-available/default

# Dar permisos de ejecución al script y ejecutarlo
# RUN chmod +x /tmp/generate_certs.sh && /tmp/generate_certs.sh

# RUN chmod -R 755 /var/www/html
# RUN chown -R www-data:www-data /var/www/html


EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]