# Skeleton PHP application with Docker

## Obrigatório

- Docker;
- Docker Compose.

## Clonando o projeto

```bash
git clone https://github.com/Diego-Brocanelli/php-docker.git NOME_DO_SEU_PROJETO
```

## Criando arquivo de configuração

```bash
cp .env-example .env
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

## [Comandos disponíveis](/docs/development/commands.md)