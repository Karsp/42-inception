# Portainer built from Alpine for defense compliance
FROM alpine:3.22

# Install dependencies
RUN apk add --no-cache curl tar ca-certificates


# Set Portainer version explicitly
ENV PORTAINER_VERSION=2.33.2
	
# Download and extract Portainer CE binary
RUN curl -L -o /tmp/portainer.tar.gz \
    https://github.com/portainer/portainer/releases/download/${PORTAINER_VERSION}/portainer-${PORTAINER_VERSION}-linux-amd64.tar.gz && \
    mkdir -p /tmp/portainer && \
    tar -xzf /tmp/portainer.tar.gz -C /tmp/portainer && \
    mv /tmp/portainer/portainer/portainer /usr/local/bin/portainer && \
    chmod +x /usr/local/bin/portainer && \
    rm -rf /tmp/portainer /tmp/portainer.tar.gz


# Create data directory
RUN mkdir -p /data

VOLUME ["/data"]
# Expose Portainer web interface on 9080 (HTTP) and 9443 (HTTPS)
EXPOSE 9443

# Run Portainer on 9080 instead of 9000 to avoid conflict with WordPress
CMD ["/usr/local/bin/portainer", "--data", "/data", "--http-disabled"]
# https://daviles-.42.fr/portainer/