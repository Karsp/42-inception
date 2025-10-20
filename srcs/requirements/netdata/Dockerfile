# Minimal Netdata Dockerfile
FROM alpine:3.22

# Install dependencies for building Netdata
RUN apk add --no-cache \
    bash \
    git \
    curl \
    tar \
    gzip \
    make \
    automake \
    autoconf \
    pkgconf \
    zlib-dev \
    gcc \
    g++ \
    libc-dev \
    libuuid \
    libmnl-dev \
    linux-headers \
    libcap-dev \
    libelf-dev \
    util-linux-dev \
    ca-certificates

# Clone and install Netdata
RUN git clone https://github.com/netdata/netdata.git /opt/netdata && \
    /opt/netdata/netdata-installer.sh --install-prefix /usr --dont-start-it --dont-wait

# Expose default Netdata port
EXPOSE 19999

# Create a volume for Netdata data
VOLUME ["/usr/lib/netdata"]

# Start Netdata
CMD ["/usr/sbin/netdata", "-D", "-s", "/usr/lib/netdata"]
ZZZ