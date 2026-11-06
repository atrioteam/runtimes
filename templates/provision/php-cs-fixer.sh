#!/bin/bash
# Wrapper per eseguire php-cs-fixer nel container Docker sul file passato come argomento.
# Uso: php-cs-fixer.sh /path/assoluto/host/al/file.php

HOST_FILE="$1"
HOST_PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CONTAINER_ROOT="/var/www/html"

# Converti path host -> path container
CONTAINER_FILE="${CONTAINER_ROOT}${HOST_FILE#$HOST_PROJECT_ROOT}"

docker compose -f "$HOST_PROJECT_ROOT/docker-compose.yaml" exec -T web \
    php /var/www/html/vendor/bin/php-cs-fixer fix \
    --config=/var/www/html/.php-cs-fixer.dist.php \
    --allow-risky=yes \
    "$CONTAINER_FILE"
