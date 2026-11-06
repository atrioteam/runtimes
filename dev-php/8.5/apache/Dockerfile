# sirfaenor/dev-php:8.5-apache
# Immagine base di sviluppo (Laravel/Filament/Marvin): php 8.5 + apache con le estensioni usate nei progetti.
#
# build & push:
#   docker build -t sirfaenor/dev-php:8.5-apache .
#   docker push sirfaenor/dev-php:8.5-apache
FROM php:8.5-apache

ARG APACHE_RUN_USER=1000
ARG APACHE_RUN_GROUP=www-data

ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN apt-get update && apt-get install -y -qq --no-install-recommends \
        git zsh zip unzip wget curl \
        libjpeg62-turbo-dev libfreetype6-dev libpng-dev \
        libssl-dev libzip-dev libcurl4-openssl-dev libonig-dev libicu-dev \
        libmagickwand-dev imagemagick ffmpeg \
        mariadb-client \
    && rm -rf /var/lib/apt/lists/*

RUN pecl install redis && docker-php-ext-enable redis

# mbstring, iconv e curl sono già compilati nell'immagine ufficiale
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd zip pdo pdo_mysql bcmath exif intl

RUN git clone https://github.com/Imagick/imagick.git --depth 1 /tmp/imagick \
    && cd /tmp/imagick \
    && phpize && ./configure && make && make install \
    && docker-php-ext-enable imagick \
    && rm -rf /tmp/imagick

# abilita la conversione di pdf/ps con ghostscript (path diverso tra ImageMagick 6 e 7)
RUN for f in /etc/ImageMagick-*/policy.xml; do sed -i '/disable ghostscript format types/,+6d' "$f"; done

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN a2enmod rewrite headers

# appuser di default (i progetti lo ricreano con uid/gid dell'utente host)
RUN useradd --uid $APACHE_RUN_USER --gid $APACHE_RUN_GROUP --shell /bin/bash --create-home appuser \
    && usermod -aG root appuser
