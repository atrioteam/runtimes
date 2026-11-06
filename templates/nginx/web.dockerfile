FROM ghcr.io/atrioteam/dev-php:{{PHP_VERSION}}-fpm

# (i nomi degli argomenti restano APACHE_* per compatibilità con il file .env)
ARG APACHE_RUN_USER
ARG APACHE_RUN_GROUP

# estensioni php e composer sono già nell'immagine (stesse di dev-php:*-apache)

# delete existing user if any
RUN userdel -r appuser >/dev/null 2>&1 || true

# recreate appuser with the correct uid/gid
RUN useradd --uid $APACHE_RUN_USER --gid $APACHE_RUN_GROUP --shell /bin/bash --create-home appuser

RUN usermod -aG root appuser

WORKDIR /var/www/html

RUN chown -R "$APACHE_RUN_USER":"$APACHE_RUN_GROUP" ./
RUN chmod -R 755 ./
