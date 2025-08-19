# PHP 8.4 Docker Environment

![Banner do Projeto](docs/images/banner.png)

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
- Make

## Sumário

- [Instalação Rápida](#instalação-rápida)
- [Opções de Configuração](#opções-de-configuração)
- [Estrutura de Diretórios](#estrutura-de-diretórios)
- [Como usar](#como-usar)
- [Comandos auxiliares](#comandos-auxiliares)
- [Customização](#customização)
- [Como contribuir](#como-contribuir)
- [Licença](#licença)

## Instalação Rápida

Baixe o repositório e execute o script de configuração:

```bash
git clone https://github.com/Diego-Brocanelli/php-docker.git [nome_projeto] \
cd [nome_projeto] \
chmod +x setup.sh \
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
├── docker/       # Diretório com arquivos Docker
├── docs/         # Diretório com a documentação do projeto
├── public/       # Raiz pública da aplicação
│   └── index.php # Arquivo inicial da aplicação
├── src/          # Diretório com o código-fonte do projeto
├── tests/        # Diretório para testes automatizados
├── .env          # Variáveis de ambiente do projeto
├── Makefile      # Comandos utilitários para Docker Compose
├── setup.sh      # Script de configuração inicial
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

> No final da execução do script o ambiente estará funcionando.

## Comandos auxiliares

```bash
# Primeira vez
make setup
make start

# Desenvolvimento diário
make logs      # Ver o que acontece
make shell     # Trabalhar no container
make restart   # Reiniciar se necessário

# Limpeza
make clean     # Limpar containers
make clean-all # Limpar tudo e reconfigurar
```

## Customização

### Configurações PHP

Adicione arquivos `.ini` personalizados em `docker/php/conf.d/`.

### Configurações Nginx

Adicione arquivos de configuração em `docker/nginx/conf.d/`.

### Scripts de Inicialização MySQL

Adicione scripts SQL em `docker/mysql/initdb.d/` para serem executados na criação do banco.

## Como contribuir

1. Faça um fork deste repositório
2. Crie uma branch para sua feature ou correção (`git checkout -b minha-feature`)
3. Faça commit das suas alterações
4. Envie um pull request

## Licença

Distribuído sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.
