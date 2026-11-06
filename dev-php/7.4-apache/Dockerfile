# sirfaenor/dev-php:7.4-apache
# Ricostruito dalla history dell'immagine pubblicata il 2024-09-23 (php 7.4.33).
# Nota: l'immagine pubblicata NON contiene estensioni aggiuntive (gd, redis, imagick, pdo_mysql...):
# installa solo i pacchetti di sistema, composer e i moduli apache. Probabile build incompleta.
FROM php:7.4-apache

ARG APACHE_RUN_USER=1000
ARG APACHE_RUN_GROUP=root

RUN apt-get update && \
    apt-get install -y -qq --no-install-recommends \
        git \
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
        imagemagick \
        ffmpeg \
        libmagickwand-dev

RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

RUN a2enmod rewrite headers
