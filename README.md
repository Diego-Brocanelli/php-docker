# Skeleton PHP application with Docker

## Obrigatório

- Docker;
- Docker Compose.

## Clonando o projeto

Clone o projeto, versione apenas o diretório `app`.

```bash
git clone https://github.com/Diego-Brocanelli/php-docker.git NOME_DO_SEU_PROJETO
```

## Instalação

Acesse a raiz do projeto, e execute o comando abaixo.

```bash
docker-compose up
```

Executar em segundo plano.

```bash
docker-compose up -d
```

## Estrutura base para o projeto

    - docs.
        - Inclua toda a documentação do projeto aqui.
    - src.
        - Diretório responsável por conter todos os códigos do seu projeto.
    - tests.
        - Diretório responsável por conter todos os testes da sua aplicação.
    .env
        - Configurações do projeto.

## Acessando o container

```bash
docker exec -it app bash
```

Dentro do container terá acesso as tecnologias listadas abaixo.

- PHP 8.1;
- PHPStan;
- PHPCs;
- Psalm;
- PHPUnit;
- PHPLoc
- Composer;
- composer-unused;
- Nodejs;
- NPM.

## Executando comandos fora do container

Acessando o PHP.
```bash
docker exec -i app php --version
```

Acessando o phpstan.
```bash
docker exec -i app phpstan --version 
```

Acessando o phpcs.
```bash
docker exec -i app phpcs --version
```

Acessando o phpunit.
```bash
docker exec -i app phpunit --version
```

Acessando o psalm.
```bash
docker exec -i app psalm --version
```

Acessando o phploc.
```bash
docker exec -i app phploc --version
```

Acessando o composer.
```bash
docker exec -i app comopser --version 
```

Acessando o composer.
```bash
docker exec -i app composer-unused --version 
```

Acessando o nodejs.
```bash
docker exec -i app node --version
```

Acessando o npm.
```bash
docker exec -i app npm --version
```
