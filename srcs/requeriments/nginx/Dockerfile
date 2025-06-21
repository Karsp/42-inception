FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y nginx openssl && \
    apt-get clean

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]