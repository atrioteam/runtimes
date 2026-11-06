# runtimes

Dockerfile delle immagini pubblicate su Docker Hub (`sirfaenor/*`).
Struttura: `<immagine>/<tag>/Dockerfile` → `sirfaenor/<immagine>:<tag>`.

Le versioni precedenti al tag 8.5 sono state ricostruite dalla history delle immagini già pubblicate
(primo commit = stato pubblicato). Le modifiche successive vanno fatte qui e committate prima del push.

## Immagini

| Immagine | Tag | PHP pubblicato | Data pubblicazione |
|---|---|---|---|
| dev-php | 8.5-apache | 8.5.11 (trixie) | 2026-10-11 |
| dev-php | 8.4-apache | 8.4.4 (bookworm) | 2025-03-12 |
| dev-php | 8.3-apache | 8.3.2 | 2024-02-05 |
| dev-php | 8.1-apache | 8.1.5 | 2022-07-05 |
| dev-php | 8.0-apache | 8.0.23 | 2022-09-20 |
| dev-php | 7.4-apache | 7.4.33 | 2024-09-23 |
| dev-php | 7.3-apache | 7.3.33 | 2023-10-06 |
| dev-php | 7.2-apache | 7.2.34 | 2023-10-06 |

## Build multi-architettura (amd64 + arm64)

Le immagini vanno pubblicate per `linux/amd64` e `linux/arm64`: sui Mac Apple Silicon
un'immagine solo amd64 gira in emulazione ed è molto più lenta.

Setup una tantum (builder buildx + emulazione arm64 su host amd64):

```bash
docker run --privileged --rm tonistiigi/binfmt --install arm64
docker buildx create --name multi --driver docker-container --use
```

Build e push di un tag:

```bash
docker buildx build --platform linux/amd64,linux/arm64 \
  -t sirfaenor/dev-php:8.5-apache --push dev-php/8.5-apache
```

Verifica delle architetture pubblicate:

```bash
docker buildx imagetools inspect sirfaenor/dev-php:8.5-apache
```
