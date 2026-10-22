# syntax=docker/dockerfile:1
#
# Contexto de build: raiz do projeto.
#   dev  -> ambiente de desenvolvimento (usado pelo compose.yml)
#   prod -> imagem de produção com o código da aplicação (make build-prod)

ARG PHP_VERSION=8.5
ARG NODE_VERSION=24

FROM node:${NODE_VERSION}-slim AS node

# =======================================
# base: PHP-FPM + extensões + Composer + usuário não-root
# =======================================
FROM php:${PHP_VERSION}-fpm AS base

LABEL maintainer="Diego Brocanelli <diegod2@msn.com>"

# Extensões extras definidas pelo setup conforme os serviços escolhidos (ex.: pdo_pgsql mongodb amqp)
ARG PHP_EXTENSIONS=""
# UID/GID do usuário do host, para que os arquivos criados no container tenham o mesmo dono
ARG UID=1000
ARG GID=1000

# Sobrescrito em tempo de execução pela variável TZ do .env
ENV TZ=UTC

RUN apt-get update -y && \
    apt-get -y --no-install-recommends install \
        ca-certificates \
        curl \
        git \
        libfcgi-bin \
        unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=mlocati/php-extension-installer:2 /usr/bin/install-php-extensions /usr/local/bin/

# Instala extensões PECL uma a uma; se o PECL estiver fora do ar, compila a tag fixa do GitHub
# (versões nos ARGs *_VERSION). O clone traz os submódulos que o redis exige; o mongodb não
# tem package.xml no repositório, então usa o pacote da release.
COPY --chmod=755 <<'EOF' /usr/local/bin/install-pecl-extensions
#!/bin/sh
set -eu
# Downloads do instalador (PECL e fallback) com novas tentativas em falhas de rede
export IPE_CURL_FLAGS="${IPE_CURL_FLAGS:---retry 3 --retry-all-errors --connect-timeout 15}"
for ext in "$@"; do
    case "$ext" in
        apcu)      src=krakjoe/apcu@${APCU_VERSION:?} ;;
        igbinary)  src=igbinary/igbinary@${IGBINARY_VERSION:?} ;;
        redis)     src=phpredis/phpredis@${REDIS_VERSION:?} ;;
        yaml)      src=php/pecl-file_formats-yaml@${YAML_VERSION:?} ;;
        mongodb)   src=https://github.com/mongodb/mongo-php-driver/releases/download/${MONGODB_VERSION:?}/mongodb-${MONGODB_VERSION}.tgz ;;
        amqp)      src=php-amqp/php-amqp@${AMQP_VERSION:?} ;;
        memcached) src=php-memcached-dev/php-memcached@${MEMCACHED_VERSION:?} ;;
        rdkafka)   src=arnaud-lb/php-rdkafka@${RDKAFKA_VERSION:?} ;;
        xdebug)    src=xdebug/xdebug@${XDEBUG_VERSION:?} ;;
        # Extensões nativas do PHP (ex.: pdo_pgsql) não dependem do PECL
        *)         install-php-extensions "$ext"; continue ;;
    esac
    install-php-extensions "$ext" && continue
    echo "PECL indisponível para $ext; compilando $src"
    dir="/tmp/ext-src/$ext"
    rm -rf "$dir" && mkdir -p "$dir"
    case "$src" in
        https://*)
            # Pacote no formato PECL: package.xml na raiz e o código em <nome>-<versão>/
            curl -fsSL --retry 3 --retry-all-errors "$src" | tar -xz -C "$dir"
            pkg="$(find "$dir" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
            cp "$dir/package.xml" "$pkg/"
            install-php-extensions "$pkg"
            ;;
        *)
            git clone -q -c advice.detachedHead=false --depth 1 --branch "${src#*@}" \
                --recurse-submodules --shallow-submodules "https://github.com/${src%@*}.git" "$dir"
            install-php-extensions "$dir"
            ;;
    esac
    rm -rf "$dir"
done
EOF

ARG APCU_VERSION=v5.1.28
# 3.2.17RC1 é a release marcada como estável no PECL e a primeira compatível com o PHP 8.5
ARG IGBINARY_VERSION=3.2.17RC1
ARG REDIS_VERSION=6.3.0
ARG YAML_VERSION=2.3.0
ARG MONGODB_VERSION=2.5.5
ARG AMQP_VERSION=v2.2.0
ARG MEMCACHED_VERSION=v3.4.0
ARG RDKAFKA_VERSION=6.0.5

# pdo, openssl, curl, tokenizer e mbstring já vêm compilados na imagem oficial
RUN install-php-extensions \
        exif \
        gd \
        intl \
        opcache \
        pcntl \
        pdo_mysql \
        zip

# igbinary antes do redis, para o redis ser compilado com suporte a ele
RUN install-pecl-extensions igbinary apcu redis yaml ${PHP_EXTENSIONS}

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

# Supercronic: cron para containers (serviço "scheduler"), roda sem root e loga em stdout
ARG TARGETARCH
ARG SUPERCRONIC_VERSION=v0.2.51
RUN case "${TARGETARCH:-amd64}" in \
        amd64) sha=cc232108374e8e2b537045f2d5eaa1229f619db314c3ba6a14d38b35dc0aa123 ;; \
        arm64) sha=4ae22576a78223d8ccdf5f3b3660a5cbb5288416bf0ca96afc4a36d195932b94 ;; \
        *) echo "Unsupported architecture: $TARGETARCH" && exit 1 ;; \
    esac && \
    curl -fsSL --retry 5 --retry-all-errors -o /usr/local/bin/supercronic \
        "https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-${TARGETARCH:-amd64}" && \
    echo "${sha}  /usr/local/bin/supercronic" | sha256sum -c - && \
    chmod +x /usr/local/bin/supercronic

# Timezone do PHP segue a variável de ambiente TZ (o php.ini expande ${TZ})
RUN echo 'date.timezone = ${TZ}' > /usr/local/etc/php/conf.d/zz-timezone.ini

# Pool do FPM: endpoint /ping usado pelo healthcheck
COPY docker/templates/services/php/fpm/zz-app.conf /usr/local/etc/php-fpm.d/zz-app.conf
COPY --chmod=755 <<'EOF' /usr/local/bin/php-fpm-healthcheck
#!/bin/sh
SCRIPT_NAME=/ping SCRIPT_FILENAME=/ping REQUEST_METHOD=GET \
    cgi-fcgi -bind -connect 127.0.0.1:9000 | grep -q pong
EOF

# Usuário não-root com o mesmo UID/GID do host
RUN (getent group "$GID" >/dev/null || groupadd --gid "$GID" appuser) && \
    (getent passwd "$UID" >/dev/null || useradd --uid "$UID" --gid "$GID" --shell /bin/bash --create-home appuser) && \
    mkdir -p /var/www/html && \
    chown "$UID:$GID" /var/www/html

WORKDIR /var/www/html

EXPOSE 9000

CMD ["php-fpm"]

# =======================================
# dev: Xdebug, Node.js (web), Deployer e php.ini de desenvolvimento
# =======================================
FROM base AS dev

# web instala Node.js; api e cli não
ARG APP_TYPE=api
ARG UID=1000
ARG GID=1000
ARG DEPLOYER_VERSION=v8.0.5
# Usado só quando o PECL está fora do ar (fallback compila a tag do GitHub)
ARG XDEBUG_VERSION=3.5.3

# Node.js copiado da imagem oficial (sem curl | bash), apenas para APP_TYPE=web
RUN --mount=type=bind,from=node,source=/usr/local,target=/opt/node \
    if [ "$APP_TYPE" = "web" ]; then \
        cp /opt/node/bin/node /usr/local/bin/node && \
        cp -r /opt/node/lib/node_modules /usr/local/lib/node_modules && \
        ln -s ../lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm && \
        ln -s ../lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx && \
        node --version && npm --version; \
    fi

# Xdebug: tenta o PECL; se estiver indisponível, compila a partir do GitHub
RUN install-pecl-extensions xdebug

RUN curl -fsSL --retry 5 --retry-all-errors -o /usr/local/bin/dep \
        "https://github.com/deployphp/deployer/releases/download/${DEPLOYER_VERSION}/deployer.phar" && \
    chmod +x /usr/local/bin/dep

# Configurações de desenvolvimento. O modo do Xdebug vem da variável XDEBUG_MODE (compose)
RUN cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini && \
    { \
        echo "xdebug.client_host=host.docker.internal"; \
        echo "xdebug.client_port=9003"; \
        echo "xdebug.start_with_request=trigger"; \
        echo "xdebug.idekey=docker"; \
    } >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Cache do Composer em volume nomeado (compose.yml), compartilhado entre rebuilds
ENV COMPOSER_CACHE_DIR=/composer-cache
RUN mkdir -p /composer-cache && chown "$UID:$GID" /composer-cache

USER ${UID}:${GID}

# =======================================
# prod: código da aplicação, sem ferramentas de desenvolvimento
# =======================================
FROM base AS prod

ARG UID=1000
ARG GID=1000

RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini && \
    { \
        echo "opcache.enable=1"; \
        echo "opcache.validate_timestamps=0"; \
        echo "opcache.memory_consumption=256"; \
        echo "opcache.max_accelerated_files=20000"; \
        echo "expose_php=Off"; \
    } > /usr/local/etc/php/conf.d/zz-production.ini

USER ${UID}:${GID}

# Dependências primeiro, para aproveitar o cache de camadas
COPY --chown=${UID}:${GID} composer.json* composer.lock* ./
RUN if [ -f composer.json ]; then \
        composer install --no-dev --no-scripts --no-autoloader --no-interaction --prefer-dist && \
        composer clear-cache; \
    fi

COPY --chown=${UID}:${GID} . .

RUN if [ -f composer.json ]; then \
        composer dump-autoload --no-dev --optimize --classmap-authoritative --no-interaction; \
    fi
