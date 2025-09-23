FROM alpine:3.22

RUN apk update && \
	apk add --no-cache nginx openssl && \
	apk clean

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]