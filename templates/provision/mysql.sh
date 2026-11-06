# add additional mysql configuration or database setup here

# Eseguito dal container db al primo avvio (cartella dati vuota).
# Per eseguirlo su un db già inizializzato (es. dopo aver abilitato il db di testing):
#   docker compose exec db bash /docker-entrypoint-initdb.d/mysql.sh
#
# NB: l'entrypoint esegue questo file con "source": non usare "exit".

# database di testing (v. TESTING_DB_* nel file .env)
if [ -n "$TESTING_DB_DATABASE" ]; then
    echo "** Creating testing database $TESTING_DB_DATABASE"

    # le immagini mariadb recenti hanno solo il client "mariadb"
    DB_CLIENT=$(command -v mariadb || command -v mysql)

    MYSQL_PWD="$MYSQL_ROOT_PASSWORD" "$DB_CLIENT" -u root --execute "
        CREATE DATABASE IF NOT EXISTS \`$TESTING_DB_DATABASE\`;
        CREATE USER IF NOT EXISTS '$TESTING_DB_USERNAME'@'%' IDENTIFIED BY '$TESTING_DB_PASSWORD';
        GRANT ALL PRIVILEGES ON \`$TESTING_DB_DATABASE\`.* TO '$TESTING_DB_USERNAME'@'%';
        GRANT SUPER ON *.* TO '$TESTING_DB_USERNAME'@'%';
        FLUSH PRIVILEGES;
    "
fi
