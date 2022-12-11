FROM php:8.1-fpm-alpine

# Set working directory
WORKDIR /var/www

RUN docker-php-ext-install pdo pdo_mysql && \
    apk add bash git

RUN apk update && apk add --no-cache \
    build-base shadow vim curl \
    php7 \
    php7-fpm \
    php7-common \
    php7-pdo \
    php7-pdo_mysql \
    php7-mysqli \
    php7-mcrypt \
    php7-mbstring \
    php7-xml \
    php7-openssl \
    php7-json \
    php7-phar \
    php7-zip \
    php7-gd \
    php7-dom \
    php7-session \
    php7-zlib

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ARG HOST_UID=1000


# Add user for laravel application
RUN addgroup -g ${HOST_UID} www
RUN adduser -S -G www -u ${HOST_UID} www

# Copy helpers binaries
RUN mkdir /tmp/bin
COPY /bin/* /tmp/bin/
RUN chmod +x /tmp/bin/*
RUN mv /tmp/bin/* /bin/

# Change current user to www
USER www

# Expose port 9000 and start php-fpm server
EXPOSE 9000
