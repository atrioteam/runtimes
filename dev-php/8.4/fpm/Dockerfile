# sirfaenor/dev-php:8.4-fpm
# Immagine base di sviluppo per i progetti con nginx: php-fpm 8.4 con le stesse estensioni di dev-php:*-apache.
# I progetti la estendono ricreando appuser con uid/gid dell'utente host (v. template nginx/web.dockerfile).
FROM php:8.4-fpm

ARG APACHE_RUN_USER=1000
ARG APACHE_RUN_GROUP=www-data

RUN apt-get update && apt-get install -y -qq --no-install-recommends \
        git zsh zip unzip wget curl \
        imagemagick ffmpeg \
        mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# estensioni (e relative dipendenze di sistema) + composer
ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN install-php-extensions bcmath exif gd imagick intl pdo_mysql redis zip @composer

# abilita la conversione di pdf/ps con ghostscript (path diverso tra ImageMagick 6 e 7)
RUN for f in /etc/ImageMagick-*/policy.xml; do sed -i '/disable ghostscript format types/,+6d' "$f"; done

# appuser di default (i progetti lo ricreano con uid/gid dell'utente host)
# (i nomi degli argomenti restano APACHE_* per compatibilità con il file .env dei progetti)
RUN useradd --uid $APACHE_RUN_USER --gid $APACHE_RUN_GROUP --shell /bin/bash --create-home appuser \
    && usermod -aG root appuser

WORKDIR /var/www/html
