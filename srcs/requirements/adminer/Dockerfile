# Base: Alpine Linux
FROM alpine:3.22

# Install PHP, required extensions, and wget for downloading Adminer
RUN apk add --no-cache php php-session php-mysqli php-pdo_mysql php-pdo php-json php-iconv php-curl php-phar php-openssl php-gd php-xml php-tokenizer php-dom wget

# Create Adminer directory
RUN mkdir -p /var/www/html

# Download the latest Adminer (standalone PHP file)
RUN wget "https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php" -O /var/www/html/index.php

# Expose Adminer on port 8080
EXPOSE 8080

# Run with PHP’s built-in web server
CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]
# https://daviles-.42.fr/adminer/