FROM alpine:3.22

RUN apk update && \
	apk add --no-cache nginx openssl

# Optional: create cert directory
#RUN mkdir -p /etc/nginx/certs

#COPY certs/server.crt /etc/nginx/certs/server.crt
#COPY certs/server.key /etc/nginx/certs/server.key


EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]