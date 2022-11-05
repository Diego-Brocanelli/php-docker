FROM php:8.1-fpm

LABEL maintainer="Diego Brocanelli <diegod2@msn.com>"

RUN apt-get update -y && \
    apt-get -y --no-install-recommends install \
        openssl \
        build-essential \
        software-properties-common \
        ca-certificates \
        gnupg \
        gettext-base \
        curl \
        wget \
        unzip \
        libicu-dev \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev 

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions gd \
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
        mcrypt \
        opcache \
        yaml 

WORKDIR /var/www/html

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN ln -s -f /root/.composer/vendor/bin/* /usr/local/bin/

RUN pecl install -o -f xdebug && \
    docker-php-ext-enable xdebug && \
    rm -rf /tmp/pear

# Configuração do Xdebug
RUN echo "xdebug.remote_enable=on" >> /usr/local/etc/php/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_port=9000" >> /usr/local/etc/php/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_connect_back=0" >> /usr/local/etc/php/docker-php-ext-xdebug.ini
RUN echo "xdebug.idekey=docker" >> /usr/local/etc/php/docker-php-ext-xdebug.ini
RUN echo "xdebug.mode=coverage" >> /usr/local/etc/php/docker-php-ext-xdebug.ini

# Instalação do Deployer
RUN curl -LO https://deployer.org/deployer.phar
RUN mv deployer.phar /usr/local/bin/dep
RUN chmod +x /usr/local/bin/dep

EXPOSE 9000

ENTRYPOINT ["php-fpm"]
