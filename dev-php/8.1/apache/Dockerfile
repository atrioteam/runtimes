# ghcr.io/atrioteam/dev-php:8.1-apache
# Ricostruito dalla history dell'immagine pubblicata il 2022-07-05 (php 8.1.5).
# Nota: nell'immagine pubblicata non ci sono appuser né document root su /public.
FROM php:8.1-apache

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
        libmagickwand-dev

RUN pecl install redis && docker-php-ext-enable redis
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install iconv
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install zip
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install curl

RUN printf "\n" | pecl install imagick
RUN docker-php-ext-enable imagick

RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

# estensioni mancanti rispetto alle altre immagini dev-php (bcmath exif gd imagick intl pdo_mysql redis zip)
ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN install-php-extensions exif intl

# abilita la conversione di pdf/ps con ghostscript (path diverso tra ImageMagick 6 e 7)
RUN for f in /etc/ImageMagick-*/policy.xml; do sed -i '/disable ghostscript format types/,+6d' "$f"; done

RUN a2enmod rewrite
RUN a2enmod headers
