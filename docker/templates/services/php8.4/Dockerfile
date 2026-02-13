FROM php:8.4-fpm

LABEL maintainer="Diego Brocanelli <diegod2@msn.com>"

# Argumento para controlar se instala Node.js
ARG APP_TYPE=api

# Configurar timezone
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Instalar dependências em uma única camada para reduzir o tamanho da imagem
RUN apt-get update -y && \
    apt-get -y --no-install-recommends install \
        openssl \
        build-essential \
        ca-certificates \
        gnupg \
        gettext-base \
        curl \
        wget \
        unzip \
        libicu-dev \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev \
        neovim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# IMPORTANTE: Atualizar certificados CA após a instalação
RUN update-ca-certificates

# Instalar Node.js apenas se APP_TYPE=web
RUN if [ "$APP_TYPE" = "web" ]; then \
        curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
        apt-get install -y nodejs && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*; \
    fi

# Instalar PHP extensions usando o script do mlocati
ADD --chmod=755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# Instalar extensões do PHP em uma única camada
RUN install-php-extensions \
        gd \
        apcu \
        pdo \
        pdo_mysql \
        intl \
        openssl \
        curl \
        tokenizer \
        mbstring \
        zip \
        exif \
        opcache \
        yaml \
        igbinary \
        REDIS && \
        install-php-extensions xdebug

WORKDIR /var/www/html

# Instalar Composer versão mais recente
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Instalar Deployer baixando o PHAR oficial do GitHub
RUN curl -LO https://github.com/deployphp/deployer/releases/latest/download/deployer.phar && \
    mv deployer.phar /usr/local/bin/dep && \
    chmod +x /usr/local/bin/dep

# Sobrescrever com as configurações de desenvolvimento
RUN cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini && \
    # Configurar Xdebug apenas no ambiente de desenvolvimento
    echo "xdebug.mode=debug,coverage" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.client_port=9003" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.idekey=docker" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Configuração de usuário não-root para melhor segurança
RUN groupadd --gid 1000 appuser && \
    useradd --uid 1000 --gid appuser --shell /bin/bash --create-home appuser

# Garantir que a pasta de trabalho pertence ao usuário da aplicação
RUN chown -R appuser:appuser /var/www/html

# Configurar permissões corretas para os diretórios do PHP-FPM
RUN mkdir -p /var/www/.composer && \
    chown -R appuser:appuser /var/www/.composer

# Mudar para o usuário não-root
USER appuser

# Expor a porta do PHP-FPM
EXPOSE 9000

# Comando de inicialização
CMD ["php-fpm"]