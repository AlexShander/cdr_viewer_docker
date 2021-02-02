FROM php:5.6-fpm-alpine

LABEL maintainer="Alexandr Shander <alexmasc05@gmail.com>"

RUN apk  --no-cache --virtual .build-deps add \ 
    build-base \
    autoconf \
    pcre-dev && \
    docker-php-ext-install mysql mysqli pdo pdo_mysql && \
    apk del .build-deps && \
    rm -rf /var/lib/apt/list/* && \
    rm -f /var/cache/apk/*

WORKDIR /var/www/html

COPY entrypoint_cdr_viewer.sh /usr/local/bin/

CMD ["-R"]

EXPOSE 9000

