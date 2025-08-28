# 🚀 PHP + Docker

![Banner do Projeto](docs/images/banner.png)

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge\&logo=docker\&logoColor=white)
![Make](https://img.shields.io/badge/Make-427819?style=for-the-badge\&logo=gnu\&logoColor=white)
![PHP](https://img.shields.io/badge/PHP-8.4-777BB4?style=for-the-badge\&logo=php\&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-269539?style=for-the-badge\&logo=nginx\&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?style=for-the-badge\&logo=mysql\&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-336791?style=for-the-badge\&logo=postgresql\&logoColor=white)
![MariaDB](https://img.shields.io/badge/MariaDB-10.11-003545?style=for-the-badge\&logo=mariadb\&logoColor=white)
![MongoDB](https://img.shields.io/badge/MongoDB-7-4EA94B?style=for-the-badge\&logo=mongodb\&logoColor=white)
![Redis](https://img.shields.io/badge/Redis-DC382D?style=for-the-badge\&logo=redis\&logoColor=white)
![RabbitMQ](https://img.shields.io/badge/RabbitMQ-FF6600?style=for-the-badge\&logo=rabbitmq\&logoColor=white)
![MailHog](https://img.shields.io/badge/MailHog-0078D7?style=for-the-badge\&logo=mail\&logoColor=white)

Um **ambiente Docker moderno para PHP 8.4**, flexível e pronto para desenvolvimento local, com suporte a múltiplos bancos, serviços e configurações.

## 🎯 Objetivo

Fornecer um ambiente **rápido e padronizado** para desenvolvimento em PHP 8.4, com serviços opcionais como Redis, RabbitMQ, PostgreSQL e mais.
Ideal para uso individual ou em equipe.

## ✨ Principais Características

* ✅ PHP 8.4 com extensões otimizadas
* ✅ Ambiente **CLI** ou **Web** (com Nginx)
* ✅ Bancos: MySQL, MariaDB, PostgreSQL, MongoDB
* ✅ Serviços extras: Redis, RabbitMQ, MailHog
* ✅ Configuração simplificada via `.env`
* ✅ Makefile com comandos prontos para o dia a dia

## ⚡ Instalação Rápida

```bash
git clone https://github.com/Diego-Brocanelli/php-docker.git [nome_projeto]
```

```bash
cd [nome_projeto]
```

```bash
make setup
```

> O script guiará a configuração inicial do ambiente.

## 🛠️ Comandos básicos

Use o `Makefile` para gerenciar os containers:

```bash
# Configura o ambiente
make setup

# Sobe os containers
make up

# Sobe os containers e acompanha os logs
make logs

# Encerra os containers
make down
```

> 📌 Para mais comandos, veja o arquivo **Makefile**.

## ⚙️ Estrutura de Diretórios

```
.
├── docker/       # Arquivos Docker e configs
├── docs/         # Documentação
├── public/       # Raiz pública da aplicação (index.php)
├── src/          # Código-fonte
├── tests/        # Testes automatizados
├── .env          # Variáveis de ambiente
├── Makefile      # Atalhos e comandos utilitários
```

## 🔧 Customização

A customização é **modular e simples**: cada serviço possui dois diretórios principais dentro de `docker/templates/services/`.

* **`config/`** → usado para colocar arquivos de configuração específicos.

  * Exemplo: `docker/templates/services/php84/config/custom.ini`
  * Pode conter ajustes de extensões, memória, upload, timezone, etc.

* **`storage/`** → usado para persistência de dados do serviço.

  * Exemplo: `docker/templates/services/mysql/storage/` guarda os dados dos bancos criados.

### Exemplos de customização:

* **PHP** → adicione um arquivo `custom.ini` em `docker/templates/services/php84/config/`
* **MySQL** → adicione um `my.cnf` em `docker/templates/services/mysql/config/`
* **Redis** → adicione configs personalizadas em `docker/templates/services/redis/config/`

> 📌 Assim você mantém as configurações isoladas por serviço.

## 🤝 Contribuição

1. Faça um **fork** do repositório
2. Crie uma branch (`git checkout -b minha-feature`)
3. Faça commit das mudanças
4. Envie um **Pull Request** 🎉

## 📜 Licença

Distribuído sob a licença MIT. Veja [LICENSE](LICENSE).
