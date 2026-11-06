# runtimes

Docker development runtimes for PHP projects: multi-arch images (Apache, nginx/FPM) and compose templates.

Immagini pubblicate su GitHub Container Registry, per `linux/amd64` e `linux/arm64`
(sui Mac Apple Silicon un'immagine solo amd64 gira in emulazione ed è molto più lenta).

Struttura: `<immagine>/<versione php>/<variante>/Dockerfile` → `ghcr.io/atrioteam/<immagine>:<versione php>-<variante>`
(es. `dev-php/8.4/fpm` → `ghcr.io/atrioteam/dev-php:8.4-fpm`).

```dockerfile
FROM ghcr.io/atrioteam/dev-php:8.4-apache
```

## Immagini

### dev-php

| Versione | apache | fpm |
|---|---|---|
| 8.5 | ✓ | ✓ |
| 8.4 | ✓ | ✓ |
| 8.3 | ✓ | ✓ |
| 8.2 | ✓ | ✓ |
| 8.1 | ✓ | ✓ |
| 8.0 | ✓ | ✓ |
| 7.4 | ✓ | ✓ |
| 7.3 | ✓ | |
| 7.2 | ✓ | |
| 5.6 | ✓ | |

- `apache`: php + apache (mod_rewrite, headers), document root su `/var/www/html/public` (dalla 8.4).
- `fpm`: php-fpm per i progetti con nginx, con le stesse estensioni delle immagini apache
  (bcmath, exif, gd, imagick, intl, pdo_mysql, redis, zip) + composer, installate con
  [docker-php-extension-installer](https://github.com/mlocati/docker-php-extension-installer).
- Tutte le immagini dalla 7.2 in su hanno le stesse estensioni (8.0-apache anche soap);
  5.6-apache ha solo mysql, mysqli e pdo_mysql.
- Le basi debian buster/bullseye (php ≤ 8.0) usano `archive.debian.org`, perché fuori supporto.

## Build e pubblicazione

Le immagini vengono costruite e pubblicate dalla GitHub Action [`build.yml`](.github/workflows/build.yml),
con ogni architettura costruita su un runner nativo (niente emulazione):

- **push** sul branch principale: solo le immagini con file modificati;
- **il 1° di ogni mese**: tutte le immagini, senza cache (aggiornamenti di sicurezza di debian/php);
- **manuale** (Actions → Build images → Run workflow): le cartelle indicate (es. `dev-php/8.4/fpm`), o tutte.

Verifica delle architetture pubblicate:

```bash
docker buildx imagetools inspect ghcr.io/atrioteam/dev-php:8.4-apache
```

Build locale di prova (solo l'architettura dell'host, senza push):

```bash
docker build -t dev-php-test:8.4-fpm dev-php/8.4/fpm
```

## Template dei progetti

`templates/` contiene i file docker dei progetti, usati da `.setup/docker.sh` del progetto base
(atrioteam/base), che scarica questo repo e genera i file nel progetto:

| Template | File generato nel progetto |
|---|---|
| `templates/<apache\|nginx>/docker-compose.yaml` | `docker-compose.yaml` |
| `templates/<apache\|nginx>/web.dockerfile` | `docker/provision/web.dockerfile` |
| `templates/nginx/default.conf` | `docker/nginx/default.conf` (solo nginx) |
| `templates/provision/*` | `docker/provision/*` (sovrascritti se diversi) |
| `templates/php/php.ini` | `docker/php/php.ini` (solo se manca) |

Segnaposto: `{{PHP_VERSION}}`, `{{DB_ENGINE}}` (mysql | mariadb), `{{DB_VERSION}}`.

`docker.sh` usa di default il branch `master`; per un altro branch, tag o commit, o per provare
modifiche locali ai template:

```bash
RUNTIMES_REF=<branch|tag|commit> ./.setup/docker.sh
RUNTIMES_DIR=~/Progetti/dev/runtimes ./.setup/docker.sh
```

## Storico Docker Hub (`sirfaenor/dev-php`)

Le immagini precedenti, solo amd64, restano su Docker Hub e non vengono più aggiornate.
I Dockerfile delle versioni precedenti alla 8.5 sono stati ricostruiti dalla history di quelle immagini
(primo commit = stato pubblicato).

| Tag | PHP pubblicato | Data pubblicazione |
|---|---|---|
| 8.5-apache | 8.5.11 (trixie) | 2026-10-11 |
| 8.4-apache | 8.4.4 (bookworm) | 2025-03-12 |
| 8.3-apache | 8.3.2 | 2024-02-05 |
| 8.1-apache | 8.1.5 | 2022-07-05 |
| 8.0-apache | 8.0.23 | 2022-09-20 |
| 7.4-apache | 7.4.33 | 2024-09-23 (build incompleta, senza estensioni php) |
| 7.3-apache | 7.3.33 | 2023-10-06 |
| 7.2-apache | 7.2.34 | 2023-10-06 |
