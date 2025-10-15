FROM alpine:3.22

# Install Redis
RUN apk update && apk add --no-cache redis

# Create a directory for Redis data
RUN mkdir -p /data && chown redis:redis /data

# Configure Redis (optional basic config)
RUN echo "save 900 1" >> /etc/redis.conf && \
    echo "save 300 10" >> /etc/redis.conf && \
    echo "save 60 10000" >> /etc/redis.conf && \
    echo "appendonly yes" >> /etc/redis.conf && \
    echo "protected-mode no" >> /etc/redis.conf && \
    echo "bind 0.0.0.0" >> /etc/redis.conf

# Expose Redis port
EXPOSE 6379

# Volume for persistent data
VOLUME ["/data"]

# Run Redis
ENTRYPOINT ["redis-server", "/etc/redis.conf"]
