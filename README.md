# Skeleton PHP application with Docker

O propósito do repositório é facilitar a criação de projetos com PHP.

Abaixo estão listadas as tecnologias disponíveis.

- PHP8.1;
- Mysql;
- NGINX;
- Redis.

## Obrigatório

- Docker;
- Docker Compose.

## Como usar

Abra o terminal, acesse o diretório onde criará o projeto e execute o comando abaixo.

```bash
wget -qO- "https://github.com/Diego-Brocanelli/php-docker/archive/refs/tags/v1.0.1.tar.gz" -O php-docker.tar.gz && \
    tar -xf php-docker.tar.gz && \ 
    mv php-docker-1.0.1 MEU_PROJETO && \
    rm php-docker.tar.gz && \
    cd MEU_PROJETO && ./install && \
    rm install
```

## Criando arquivo de configuração

```bash
cp .env-example .env
```

## Instalação

Acesse a raiz do projeto, execute o comando abaixo.

```bash
docker-compose up
```

Executar em segundo plano.

```bash
docker-compose up -d
```

## Estrutura base para o projeto

    - docs
        - Responsável por conter todas as documentações do projeto.
    - src
        - Responsável por conter todos os códigos do projeto.
    - tests
        - Responsável por conter todos os testes do projeto.
    .env
        - Configurações do projeto.

## Acessando o bash

```bash
docker exec -it app bash
```

Dentro do container terá acesso as tecnologias listadas abaixo.

- Composer;
- Composer-unused;
- Nodejs;
- NPM;
- PHP 8.1;
- PHPCs;
- PHPLoc;
- PHPStan;
- PHPUnit;
- Psalm.

## [Comandos disponíveis](/docs/development/commands.md)