FROM nginx:1.28.0-alpine

RUN apk update \
    apk add bash vim

RUN rm /etc/nginx/conf.d/default.conf

COPY ./conf.d/default.conf /etc/nginx/conf.d
