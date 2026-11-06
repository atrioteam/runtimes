# ghcr.io/atrioteam/dev-php:7.2-apache
# Ricostruito dalla history dell'immagine pubblicata il 2023-10-06 (php 7.2.34).
FROM php:7.2-apache

# debian buster/bullseye è EOL: i pacchetti sono ormai solo su archive.debian.org
RUN sed -ri 's#http://(deb|security)\.debian\.org#http://archive.debian.org#' /etc/apt/sources.list

ARG APACHE_RUN_USER=1000
ARG APACHE_RUN_GROUP=www-data

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
        zsh

RUN docker-php-ext-configure gd
RUN docker-php-ext-install -j$(nproc) gd iconv mbstring zip pdo pdo_mysql bcmath curl

RUN apt-get install -y libmagickwand-dev --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN printf "\n" | pecl install imagick
RUN docker-php-ext-enable imagick

RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

# estensioni mancanti rispetto alle altre immagini dev-php (bcmath exif gd imagick intl pdo_mysql redis zip)
ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN install-php-extensions exif intl redis

# abilita la conversione di pdf/ps con ghostscript (path diverso tra ImageMagick 6 e 7)
RUN for f in /etc/ImageMagick-*/policy.xml; do sed -i '/disable ghostscript format types/,+6d' "$f"; done

RUN a2enmod rewrite
RUN a2enmod headers

RUN usermod -aG root appuser
RUN chown -R "$APACHE_RUN_USER":"$APACHE_RUN_GROUP" ./
RUN chmod -R 755 ./
