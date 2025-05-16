# PHP 8.4 Docker Environment

![PHP Version](https://img.shields.io/badge/PHP-8.4-blue)
![MySQL Version](https://img.shields.io/badge/MySQL-8.0-orange)
![Redis Version](https://img.shields.io/badge/Redis-7.0-red)

Um ambiente Docker moderno e configurável para desenvolvimento PHP 8.4, oferecendo flexibilidade para diferentes necessidades de projeto.

## Objetivo

Este projeto fornece um ambiente Docker pronto para desenvolvimento PHP 8.4, facilitando a configuração de projetos modernos com MySQL, Redis e Nginx, ideal para equipes e desenvolvedores individuais.

## Características

- PHP 8.4 com extensões otimizadas
- Suporte para ambiente CLI ou Web (com Nginx)
- Banco de dados MySQL 8.0
- Suporte opcional para Redis 7.0
- Configuração via variáveis de ambiente
- Scripts de inicialização simplificados

## Requisitos

- Docker
- Docker Compose

## Instalação Rápida

Baixe o repositório e execute o script de configuração:

```bash
git clone https://github.com/seu-usuario/php84-docker.git [nome_projeto]
cd [nome_projeto]
chmod +x setup.sh
./setup.sh
```

O script irá guiá-lo através do processo de configuração e inicialização dos contêineres.

## Opções de Configuração

O script `setup.sh` permite personalizar seu ambiente:

```bash
# Ambiente web completo (PHP + Nginx + MySQL)
./setup.sh --web

# Apenas ambiente CLI (PHP + MySQL)
./setup.sh --cli

# Adicionar Redis ao ambiente
./setup.sh --web --with-redis

# Usar um arquivo .env específico
./setup.sh --env meu-ambiente.env
```

Para ver todas as opções disponíveis:

```bash
./setup.sh --help
```

## Estrutura de Diretórios

```
.
├── compose.yml            # Configuração Docker Compose principal
├── Makefile               # Comandos utilitários para Docker/Compose
├── .env                   # Variáveis de ambiente do projeto
├── .env.example           # Exemplo de variáveis de ambiente
├── setup.sh               # Script de configuração inicial
├── public/                # Raiz pública da aplicação
│   └── index.php          # Arquivo inicial da aplicação
├── tests/                 # Diretório para testes automatizados
├── docker/                # Diretório com arquivos Docker
│   ├── Dockerfile         # Dockerfile do PHP
│   ├── mysql/             # Configurações e scripts do MySQL
│   │   ├── conf.d/        # Arquivos de configuração do MySQL
│   │   └── initdb.d/      # Scripts de inicialização do MySQL
│   ├── nginx/             # Configurações do Nginx
│   │   ├── conf.d/        # Arquivos de configuração do Nginx
│   │   └── ssl/           # Certificados SSL para o Nginx
│   ├── php/               # Configurações do PHP
│   │   └── conf.d/        # Arquivos .ini personalizados para PHP
│   └── redis/             # Configurações do Redis (se houver)
└── README.md              # Documentação do projeto
```

## Variáveis de Ambiente

Copie o arquivo `.env.example` para `.env` e personalize conforme necessário:

```bash
cp .env.example .env
```

Principais variáveis:

- `PROJECT_NAME`: Nome do projeto (afeta nomes dos contêineres)
- `APP_ENV`: Ambiente (development/production)
- `MYSQL_ROOT_PASSWORD`: Senha do root do MySQL
- `NGINX_PORT`: Porta para acessar o servidor web

## Uso

### Acessando o Container PHP

```bash
docker exec -it [nome-projeto]-php bash
```

### Executando Comandos PHP

```bash
docker exec -it [nome-projeto]-php php artisan migrate  # Exemplo Laravel
docker exec -it [nome-projeto]-php composer install     # Instalação de dependências
```

### Parando o Ambiente

```bash
docker-compose down
```

### Reiniciando o Ambiente

```bash
docker-compose up -d
```

## Como usar

1. Clone o repositório e execute o script de configuração:
   ```bash
   git clone https://github.com/seu-usuario/php84-docker.git
   cd php84-docker
   chmod +x setup.sh
   ./setup.sh
   ```
2. Siga as instruções do script para definir o nome do projeto e opções desejadas.
3. Suba o ambiente:
   ```bash
   make up
   ```
4. Acesse o container PHP:
   ```bash
   make sh
   ```
5. Para parar o ambiente:
   ```bash
   make down
   ```

## Comandos Disponíveis

- `make up` — Sobe todos os containers em segundo plano.
- `make down` — Para e remove todos os containers.
- `make sh` — Sobe o ambiente e acessa o bash do container PHP principal.

## Customização

### Configurações PHP

Adicione arquivos `.ini` personalizados em `docker/php/conf.d/`.

### Configurações Nginx

Adicione arquivos de configuração em `docker/nginx/conf.d/`.

### Scripts de Inicialização MySQL

Adicione scripts SQL em `docker/mysql/initdb.d/` para serem executados na criação do banco.

## Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou enviar pull requests.

## Como contribuir

1. Faça um fork deste repositório
2. Crie uma branch para sua feature ou correção (`git checkout -b minha-feature`)
3. Faça commit das suas alterações
4. Envie um pull request

## Licença

Distribuído sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.
