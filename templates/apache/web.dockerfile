FROM ghcr.io/atrioteam/dev-php:{{PHP_VERSION}}-apache

ARG APACHE_RUN_USER
ARG APACHE_RUN_GROUP

# delete existing user if any
RUN userdel -r appuser >/dev/null || true

# recreate appuser with the correct uid/gid
RUN useradd --uid $APACHE_RUN_USER --gid $APACHE_RUN_GROUP --shell /bin/bash --create-home appuser

RUN usermod -aG root appuser

RUN chown -R "$APACHE_RUN_USER":"$APACHE_RUN_GROUP" ./
RUN chmod -R 755 ./
