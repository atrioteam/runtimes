# sirfaenor/dev-php:8.0-apache
# Ricostruito dalla history dell'immagine pubblicata il 2022-09-20 (php 8.0.23).
FROM php:8.0-apache

ARG APACHE_RUN_USER=1000
ARG APACHE_RUN_GROUP=root

RUN useradd --uid $APACHE_RUN_USER --gid $APACHE_RUN_GROUP --shell /bin/bash --create-home appuser

RUN apt-get update && \
    apt-get install -y -qq git \
        libjpeg62-turbo-dev \
        apt-transport-https \
        libfreetype6-dev \
        libmcrypt-dev \
        libpng-dev \
        libssl-dev \
        libzip-dev \
        zip unzip \
        wget \
        libjpeg-dev \
        libfreetype6-dev \
        curl \
        libcurl3-dev \
        libonig-dev \
        git \
        zsh \
        libxml2-dev

RUN pecl install redis && docker-php-ext-enable redis
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install iconv
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install zip
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install bcmath curl
RUN docker-php-ext-install soap

RUN apt-get install -y libmagickwand-dev --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN printf "\n" | pecl install imagick
RUN docker-php-ext-enable imagick

RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

RUN a2enmod rewrite
RUN a2enmod headers

RUN usermod -aG root appuser
RUN chown -R "$APACHE_RUN_USER":"$APACHE_RUN_GROUP" ./
RUN chmod -R 755 ./
