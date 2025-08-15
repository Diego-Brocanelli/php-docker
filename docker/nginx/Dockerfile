FROM nginx:1.24-alpine

RUN apk update \
    apk add bash vim

RUN rm /etc/nginx/conf.d/default.conf

COPY ./confd/default.conf /etc/nginx/conf.d
