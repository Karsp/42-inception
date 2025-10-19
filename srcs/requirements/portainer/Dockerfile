# Portainer built from Alpine for defense compliance
FROM alpine:3.22

# Install dependencies
RUN apk add --no-cache curl tar ca-certificates


# Set Portainer version explicitly
ENV PORTAINER_VERSION=2.33.2
# Download and extract Portainer CE binary
RUN curl -L -o /tmp/portainer.tar.gz \
    https://github.com/portainer/portainer/releases/download/${PORTAINER_VERSION}/portainer-${PORTAINER_VERSION}-linux-amd64.tar.gz && \
    tar xzf /tmp/portainer.tar.gz -C /usr/local/bin && \
    rm /tmp/portainer.tar.gz

# Create data directory
RUN mkdir -p /data

EXPOSE 9000
VOLUME ["/data"]

# Start Portainer
CMD ["/usr/local/bin/portainer", "--data", "/data", "--http", ":9000"]
