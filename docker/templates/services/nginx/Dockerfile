# syntax=docker/dockerfile:1
# Imagem de produção do Nginx (make build-prod). Contexto de build: raiz do projeto.
FROM nginx:1.30-alpine

COPY docker/templates/services/nginx/config/default.conf /etc/nginx/conf.d/default.conf
COPY public/ /var/www/html/public/
